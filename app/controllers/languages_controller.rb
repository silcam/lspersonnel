class LanguagesController < ApplicationController
  def index
    @languages = Language.all
    @regions = Region.all
  end

  def new
    @language = Language.new
    @regions = Region.all
  end

  def edit
    @language = Language.find(params[:id])

    @regions = Region.all
    @departments = Department.all.order(:region_id)
  end

  def create
    @language = Language.new(language_params)

    if (@language.valid?)
      @language.save
      redirect_to languages_path()
    else
      @regions = Region.all
      @departments = Department.all.order(:region_id)
      render 'new'
    end
  end

  def update
    @language = Language.find(params[:id])

    if @language.update language_params
      redirect_to languages_path()
    else
      @regions = Region.all
      @departments = Department.all.order(:region_id)
      render 'new'
    end
  end

  private

  def language_params
    permitted = [
      :name,
      department_ids: []
    ]
    params.require(:language).permit(permitted)
  end

end
