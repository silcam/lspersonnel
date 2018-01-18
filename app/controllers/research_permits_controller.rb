class ResearchPermitsController < ApplicationController

  def new
    @person = Person.find(params[:person_id])
    @permit = ResearchPermit.new
    @languages = @person.languages.distinct
  end

  def create
    @person = Person.find(params[:person_id])
    language = Language.find(params[:research_permit][:language_id])
    @permit = ResearchPermit.new(research_permit_params)
    @permit.person = @person
    @permit.language = language

    if (@permit.valid?)

      @permit.save

      redirect_to @person
    else
      @languages = @person.languages.distinct
      render 'new'
    end
  end

  private

  def research_permit_params
    permitted = [
      :issue_date,
      :expiry_date,
      :submission_date,
      :identifier,
      :language_id
    ]
    params.require(:research_permit).permit(permitted)
  end

end
