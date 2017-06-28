class LanguagesController < ApplicationController
  def index
    @languages = Language.all
    @regions = Region.all
  end

  
end
