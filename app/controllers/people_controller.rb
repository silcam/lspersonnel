class PeopleController < ApplicationController
    def index
        @people = Person.all
        @languages = Language.all
    end

    def show

    end

   
end
