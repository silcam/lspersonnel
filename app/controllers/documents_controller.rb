class DocumentsController < ApplicationController

  def index
    @person = Person.find(params[:person_id])
  end

  def first_request
    @person = Person.find(params[:person_id])

    tmpfile = Tempfile.new('gen-doc')
    begin
      file_path = GeneratedDocument.first_request(@person, tmpfile)

      doc = File.read file_path
      # this MIME type could be longer...
      send_data doc,
          type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          disposition: "attachment",
          filename: "first_request_#{@person.filename}.docx"
    ensure
      tmpfile.close
      tmpfile.unlink
    end
  end

  private

end
