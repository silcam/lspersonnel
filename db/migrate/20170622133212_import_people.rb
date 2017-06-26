class ImportPeople < ActiveRecord::Migration[5.1]
    def up
    failed_records = []
    File.open('import/people.csv', 'r') do |csvfile|
      header = csvfile.gets
      while line = csvfile.gets
        params = line.split('|')
        id = params[0]
        first_name = params[2][1..-2] unless params[2].nil? 
        p first_name
        last_name = params[1][1..-2] unless params[1].nil?  
        category = params[6]
        job = params[7][1..-2] unless params[7].nil? 
        arrival = params[11]
        departure = params[10]
        nationality = params[15]
        title = params[16]
        gender = set_gender(params[17])
        language_id = params[25]
        failed_records << line unless Person.create(
          id: id, last_name: last_name, first_name: first_name, category: category, job: job, arrival: arrival, departure: departure, nationality: nationality, title: title, gender: gender, language_id: language_id )
      end
    end
    p "Failed Records:"
    failed_records.each{|line| p line}
  end

  def set_gender genderparams
    case genderparams
    when "1"
      gender = 'M'
    when "2"
      gender ='F'
    when "3"
      gender='U'
    end
    return gender
  end

  def set_title title
   
  end
  
  def set_language language_id
    lang = languages.find(language_id)
    return lang.name
  end
  
  def set_nationnality nationality
  end
  
  
end
