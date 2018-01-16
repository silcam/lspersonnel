require 'test_helper'
require 'sablon'
require 'henkei'

class DocumentReplacementTest < ActiveSupport::TestCase

  test "Basic Document" do

    @base_path = File.expand_path("../../", __FILE__)

    @template_path = @base_path + "/fixtures/files/replace_test_word_doc.docx"
    @output_path = @base_path + "/fixtures/files/output_file.docx"
    template = Sablon.template(@template_path)

    context = {
      text_to_replace: "This is my Fabulous Text Replacement"
    }

    template.render_to_file(@output_path, context)

    file_data = File.read(@output_path)
    file_text = Henkei.read :text, file_data

    assert_match("Fabulous", file_text, "should contain replacement text")

  end
end
