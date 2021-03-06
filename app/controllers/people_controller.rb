class PeopleController < ApplicationController

  def index
    @people = Person.all
    @languages = Language.all
  end

  def show
    @person = Person.find(params[:id])
    @levels = InvolvementLevel.all
    @languages = Language.all

    @leaves = Leave.leave_type_hash(@person)
  end

  def new
    @person = Person.new

    @languages = Language.order(:name)
    @titles = Title.all
    @nationalities = Nationality.all
  end

  def create
    @person = Person.new(person_params)

    if @person.valid?
      @person.save
      redirect_to @person
    else
      render 'new'
    end
  end

  def edit
    @person = Person.find(params[:id])

    @titles = Title.all
    @nationalities = Nationality.all
  end

  def update
    @person = Person.find(params[:id])

    if @person.update person_params
      redirect_to @person
    else
      @titles = Title.all
      @nationalities = Nationality.all

      render 'edit'
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    redirect_to people_path()
  end

  def attach
    @person = Person.find(params[:person_id])

    involvement_id = params[:person]['involvement_ids']
    lang_id = params[:person]['language_ids']

    level = InvolvementLevel.id(involvement_id)
    language = Language.find(lang_id)

    involvement = Involvement.new()
    involvement.level = level.id
    involvement.language = language

    @person.involvements << involvement

    @levels = InvolvementLevel.all
    @languages = Language.all

    redirect_to @person
  end

  private

  def person_params
    permitted = [
      :first_name,
      :last_name,
      :category,
      :job,
      :arrival,
      :departure,
      :nationality_id,
      :title_id,
      :gender,
      :future_activities,
      :request_period
    ]
    params.require(:person).permit(permitted)
  end

end
