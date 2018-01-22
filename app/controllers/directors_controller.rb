class DirectorsController < ApplicationController
  before_action :set_director, only: [:edit, :update, :destroy]

  def index
    @directors = Director.all
  end

  def new
    @director = Director.new
  end

  def edit
  end

  def create
    @director = Director.new(director_params)

    if @director.save
      redirect_to directors_path(), notice: 'Director was successfully created.'
    else
      render :new
    end
  end

  def update
    if @director.update(director_params)
      redirect_to directors_path(), notice: 'Director was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @director.destroy
    redirect_to directors_path(), notice: 'Director was successfully destroyed.'
  end

  private
    def set_director
      @director = Director.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def director_params
      params.require(:director).permit(:name, :title, :current)
    end
end
