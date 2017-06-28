class PagesController < ApplicationController
  def home
    @people = Person.all
    @lang = Language.all
    @region = Region.all
    if params[:key_word] != nil
      @request = Person.where(first_name: params[:key_word].capitalize)
    end
  end

   def search
     
    end
end
