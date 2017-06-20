class ImportLanguages < ActiveRecord::Migration[5.1]
  def up
    failed_records = []
    File.open('import/languages.csv', 'r') do |csvfile|
      header = csvfile.gets
      while line = csvfile.gets
        params = line.split('|')
        id = params[0]
        name = params[1][1..-2]  # Take off the quote marks
        region_id = params[3]
        failed_records << line unless Language.create(
          id: id, name: name, region_id: region_id)
      end
    end
    p "Failed Records:"
    failed_records.each{|line| p line}
  end

  def down
    # Nothing
  end
end
