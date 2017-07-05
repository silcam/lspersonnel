class PeopleController < ApplicationController
  def index
    @people = Person.all
    @languages = Language.all
  end

  def new
    @languages = Language.order(:name)
  end

  def create
    Person.create params[:person] 
    # last_name: params[:last_name], first_name: params[:first_name], category: params[:category], job: params[:job], arrival: params[:arrival], departure: params[:departure], nationality: params[:nationality], title: params[:title], gender: params[:gender], language_id: params[:language]
    redirect_to people_path
    puts params
  end

  def dash
    @people = Person.all
    @lang = Language.all
    @region = Region.all
    if params[:key_word] != nil
      @request = Person.where(first_name: params[:key_word].capitalize)
    end

    def show
      @person = Person.find(params[:id])
      @lang= Language.all
    end
    
  end
end
