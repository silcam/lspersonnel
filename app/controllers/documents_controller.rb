class DocumentsController < ApplicationController

  def index
    @person = Person.find(params[:person_id])
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])

    if @document.update document_params
      redirect_to edit_document_url(@document), alert: 'Saved.'
    else
      render 'edit', alert: 'Error.'
    end
  end

  def first_request
    @person = Person.find(params[:person_id])

    tmpfile = Tempfile.new('gen-doc')
    begin
      file_path = Document.first_request(@person, tmpfile)

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

  def renew_permit
    @person = Person.find(params[:person_id])

    tmpfile = Tempfile.new('gen-doc')
    begin
      file_path = Document.renew_permit(@person, tmpfile)

      doc = File.read file_path
      # this MIME type could be longer...
      send_data doc,
          type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          disposition: "attachment",
          filename: "renew_permit_#{@person.filename}.docx"
    rescue
      redirect_to person_documents_path(@person), alert: "Error creating renewal document, does user have existing research permits?"
    ensure
      tmpfile.close
      tmpfile.unlink
    end
  end

  private

  def document_params
    permitted = [
      :minister_gender
    ]
    params.require(:document).permit(permitted)

  end

end
