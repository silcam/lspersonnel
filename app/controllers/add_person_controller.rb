class AddPersonController < ApplicationController
  def index
    @languages = Language.all
  end

    def create
      Person.create last_name: params[:last_name], first_name: params[:first_name], category: params[:category], job: params[:job], arrival: params[:arrival], departure: params[:departure], nationality: params[:nationality], title: params[:title], gender: params[:gender], language_id: params[:language]
      redirect_to "/add_person"
      puts params
    end
end
