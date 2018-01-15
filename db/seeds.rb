# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'yaml'

# There should only be one record in this table
while MinForm.all.size > 0
  MinForm.first.delete
end

data = YAML.load_file('db/min_forms.yml')

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
Region.all.each do |r|
  r.delete
end

data = YAML.load_file('db/regions.yml')

data["regions"].each do |k,v|
  region = Region.new

  region.region_code = k
  region.en = v["en"]
  region.fr = v["fr"]
  region.full_en = v["full_en"]
  region.full_fr = v["full_fr"]

  region.save

end
