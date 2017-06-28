class AddLanguageController < ApplicationController
  def index
     @regions = Region.all
  end


  def create
   Language.create name: params[:name], region_id: params[:region]
   redirect_to "/add_language"
  end 
end
