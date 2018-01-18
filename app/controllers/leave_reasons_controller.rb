class LeaveReasonsController < ApplicationController

  def index
    @reasons = LeaveReason.all
  end

  def new
    @reason = LeaveReason.new
  end

  def create
    @reason = LeaveReason.new(reason_params)

    if @reason.valid?
      @reason.save
      redirect_to leave_reasons_path()
    else
      render 'new'
    end
  end

  def show
    @reason = LeaveReason.find(params[:id])
  end

  private

  def reason_params
    permitted = [
      :reason
    ]
    params.require(:leave_reason).permit(permitted)
  end

end
