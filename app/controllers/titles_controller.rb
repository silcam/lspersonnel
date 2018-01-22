class TitlesController < ApplicationController
  before_action :set_title, only: [:edit, :update, :destroy]

  def index
    @titles = Title.all
  end

  def new
    @title = Title.new
  end

  def edit
  end

  def create
    @title = Title.new(title_params)

    if @title.save
      redirect_to titles_path(), notice: 'Title was successfully created.'
    else
      render :new
    end
  end

  def update
    if @title.update(title_params)
      redirect_to titles_path(), notice: 'Title was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @title.destroy
    redirect_to titles_url, notice: 'Title was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_title
      @title = Title.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def title_params
      params.require(:title).permit(:title)
    end
end
