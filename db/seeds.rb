require 'yaml'

# There should only be one record in this table
while MinForm.all.size > 0
  MinForm.first.delete
end

data = YAML.load_file('db/load/min_forms.yml')

minform = MinForm.new
minform.top_left = data["top_left"]
minform.top_right = data["top_right"]
minform.centre = data["centre"]
minform.permit_no = data["permit_no"]
minform.decree1 = data["decree1"]
minform.decree1_fr = data["decree1_fr"]
minform.decree2 = data["decree2"]
minform.decree2_fr = data["decree2_fr"]
minform.decree3 = data["decree3"]
minform.decree3_fr = data["decree3_fr"]
minform.decree4 = data["decree4"]
minform.decree4_fr = data["decree4_fr"]
minform.decree5 = data["decree5"]
minform.decree5_fr = data["decree5_fr"]
minform.save

# Delete all regions first.
Region.all.each { |r| r.delete }

data = YAML.load_file('db/load/regions.yml')

data["regions"].each do |k,v|
  region = Region.new

  region.region_code = k
  region.en = v["en"]
  region.fr = v["fr"]
  region.full_en = v["full_en"]
  region.full_fr = v["full_fr"]

  region.save
end

# Delete all departments first.
Department.all.each { |d| d.delete }

data = YAML.load_file('db/load/departments.yml')

data["departments"].each do |k,v|
  region = Region.where("region_code = ?", v["region"])

  d = Department.new
  d.name = k
  d.gender = v["gender"]
  d.region = region.take

  d.save
end
