class ImportRegions < ActiveRecord::Migration[5.1]
  def up
    failed_records = []
    File.open('import/regions.csv', 'r') do |csvfile|
      header = csvfile.gets
      while line = csvfile.gets
        params = line.split('|')
        id = params[0]
        name = params[1].chomp[1..-2]  # Take off the quote marks
        failed_records << line unless Region.create(id: id, name: name)
      end
    end
    failed_records.each{|line| p line}
  end

  def down
    # Do nothing
  end
end
