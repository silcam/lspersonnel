class NationalitiesController < ApplicationController
  before_action :set_nationality, only: [:edit, :update, :destroy]

  def index
    @nationalities = Nationality.all
  end

  def new
    @nationality = Nationality.new
  end

  def edit
  end

  def create
    @nationality = Nationality.new(nationality_params)

    if @nationality.save
      redirect_to nationalities_path(), notice: 'Nationality was successfully created.'
    else
      render :new
    end
  end

  def update
    if @nationality.update(nationality_params)
      redirect_to nationalities_path, notice: 'Nationality was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @nationality.destroy
    redirect_to nationalities_url, notice: 'Nationality was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nationality
      @nationality = Nationality.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nationality_params
      params.require(:nationality).permit(:nationality)
    end
end
