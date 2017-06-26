  def up
    failed_records = []
    File.open('people.csv', 'r') do |csvfile|
      header = csvfile.gets
      while line = csvfile.gets
        params = line.split('|')
        id = params[0]
        first_name = params[2]
        last_name = params[1]
        category = params[6]
        job = params[7]
        arrival = params[11]
        departure = params[10]
        nationality = params[15]
        title = params[16]
        gender =params[17]
        language_id = params[25]
        
        failed_records << line 
      end
    end
    p "Failed Records:"
    failed_records.each{|line| p line}
  end