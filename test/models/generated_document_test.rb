require 'test_helper'
require 'sablon'
require 'henkei'

class PersonTest < ActiveSupport::TestCase

  test "First Request Can be Generated" do
    on_date(Date.new(2018,1,2)) do

      # person to generate document for
      person1 = Person.new
      person1.first_name = "First"
      person1.last_name = "LASTM"
      person1.nationality = nationalities :samoan
      person1.gender = "M"
      person1.title = titles :mechanic

      dir = directors :director_current

      tmpfile = Tempfile.new('test-gen-doc')

      begin
        file_path = GeneratedDocument.first_request(person1, tmpfile)
        assert(file_path, "file path after generate should exist")

        doc = File.read file_path
        file_text = Henkei.read :text, doc

        assert_match("Yaoundé, le 02 Jan 2018", file_text,
            "should contain 'today's' date in the document.")
        assert_match("Demande d'autorisation de recherche pour M. LASTM First", file_text,
            "should contain replacement text with researcher name")
        assert_match("#{dir.name}\n#{dir.title}\nSIL", file_text,
            "should contain replacement text with director information")
        assert_match("de l'intéressé plus", file_text,
            "should contain replacement text with adjective ending")
        assert_match("en faveur de M. LASTM First.", file_text,
            "should contain replacement text with researcher name in place #2")
        assert_match("Madame le Ministre,\n\nJ'ai l'honneur", file_text,
            "should contain replacement text with minister gender")
      ensure
        tmpfile.close
        tmpfile.unlink
      end

    end
  end

end
