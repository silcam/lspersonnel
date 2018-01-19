class ResearchPermitsController < ApplicationController

  def new
    @person = Person.find(params[:person_id])
    @research_permit = ResearchPermit.new
    @languages = @person.languages.distinct
  end

  def create
    @person = Person.find(params[:person_id])
    language = Language.find(params[:research_permit][:language_id])
    @research_permit = ResearchPermit.new(research_permit_params)
    @research_permit.person = @person
    @research_permit.language = language

    if (@research_permit.valid?)

      @research_permit.save

      redirect_to @person
    else
      @languages = @person.languages.distinct
      render 'new'
    end
  end

  def edit
    @person = Person.find(params[:person_id])
    @research_permit = ResearchPermit.find(params[:id])
    @languages = @person.languages.distinct
  end

  def update
    @person = Person.find(params[:person_id])
    @research_permit = ResearchPermit.find(params[:id])

    if (@research_permit.update(research_permit_params))
      @research_permit.save

      redirect_to @person
    else
      @research_permit.valid?
      @languages = @person.languages.distinct

      render 'edit'
    end
  end

  def destroy
    @person = Person.find(params[:person_id])
    @research_permit = ResearchPermit.find(params[:id])

    @person.research_permits.delete(@research_permit)
    @research_permit.destroy

    redirect_to @person
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
