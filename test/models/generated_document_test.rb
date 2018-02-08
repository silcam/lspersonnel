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

      person1.future_activities = "To not sell anything, buy anything, or process anything"
      person1.request_period = "six mois"

      ewondo = languages :Ewondo
      inv = Involvement.new
      inv.level = InvolvementLevel::PRIMARY.id
      inv.language = ewondo
      person1.involvements << inv

      dir = directors :director_current

      tmpfile = Tempfile.new('test-gen-doc')

      begin
        # Set the locale to french to test date formats
        # for this test.
        tmp_locale = I18n.locale
        I18n.locale = "en"

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

        assert_match("les activités suivantes : \n#{person1.future_activities}", file_text,
            "letter contains future plans")
        assert_match("sollicitée pour une période de six mois", file_text,
            "request period is in the letter")
        assert_match("d'aborder ses recherches #{person1.research_statement}",
            file_text, "research statement is in the letter")

        # set it back to how it was.
        I18n.locale = tmp_locale
      ensure
        tmpfile.close
        tmpfile.unlink
      end
    end
  end

  test "Handle Errors that prevent document from being generated" do

    newguy = people :newguy
    assert_equal(0, newguy.research_permits.size, "new guy has no permits")

    # Attempt to renew with zero permits
    tmpfile = Tempfile.new('test-gen-doc')

    error = assert_raise(StandardError) do
      begin
        file_path = GeneratedDocument.renew_permit(newguy, tmpfile)
      ensure
        tmpfile.close
        tmpfile.unlink
      end
    end

    assert_equal(GeneratedDocument::RENEWAL_ERROR, error.message)
  end

  test "Renewal Doc Can be Generated" do
    on_date(Date.new(2018,2,1)) do

      # person to generate document for
      researcher = people :researcher
      dir = directors :director_current

      researcher.future_activities = "To not sell anything, buy anything, or process anything"
      researcher.request_period = "un an"

      lamnso = languages :Lamnso
      inv= Involvement.new
      inv.level = InvolvementLevel::PRIMARY.id # need to be enum
      inv.language = lamnso
      researcher.involvements << inv

      tmpfile = Tempfile.new('test-gen-doc')

      begin
        # Set the locale to french to test date formats
        # for this test.
        tmp_locale = I18n.locale
        I18n.locale = "fr"

        file_path = GeneratedDocument.renew_permit(researcher, tmpfile)
        assert(file_path, "file path after generate should exist")

        doc = File.read file_path
        file_text = Henkei.read :text, doc

        assert_match("Yaoundé, le 01 fév. 2018", file_text,
            "should contain 'today's' date in the document (IN FRENCH).")
        assert_match("#{dir.name}\n#{dir.title}\nSIL", file_text,
            "should contain replacement text with director information")
        assert_match("de l'intéressée plus", file_text,
            "should contain replacement text with adjective ending")
        assert_match("en faveur de Mme. RESEARCHER Intelligent.", file_text,
            "should contain replacement text with researcher name in place #2")
        assert_match("Madame le Ministre,\nJ'ai l'honneur", file_text,
            "should contain replacement text with minister gender")
        assert_match("par notre lettre du 22 déc. 2017", file_text,
            "should contain previous letter date")
        assert_match("de recherche No. 1234-1234-2222 en faveur", file_text,
            "should contain research permit number")

        assert_match("les activités suivantes : #{researcher.future_activities}", file_text,
            "letter contains future plans")
        assert_match("sollicitée pour une période d'un an", file_text,
            "request period is in the letter")
        assert_match("de continuer ses recherches #{researcher.research_statement}",
            file_text, "research statement is in the letter")

        # set it back to how it was.
        I18n.locale = tmp_locale
      ensure
        tmpfile.close
        tmpfile.unlink
      end
    end
  end

end
