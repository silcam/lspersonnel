class LanguagesController < ApplicationController
  def index
    @languages = Language.all
    @regions = Region.all
  end

  def create
   Language.create name: params[:name], region_id: params[:region]
   redirect_to "/languages"
  end 
end
