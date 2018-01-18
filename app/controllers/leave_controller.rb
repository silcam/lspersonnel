class LeaveController < ApplicationController

  def new
    @person = Person.find(params[:person_id])
    @reasons = LeaveReason.all
    @leave = Leave.new
  end

  def create
    @person = Person.find(params[:person_id])
    @leave = Leave.new(leave_params)

    @leave.person = @person
    reasons_hash = params[:reason]
    reasons_hash.each do |k,v|
      if (v == "1")
        @leave.leave_reasons << LeaveReason.find(k)
      end
    end

    if @leave.valid?
      @leave.save
      redirect_to @person
    else
      @reasons = LeaveReason.all
      render 'new'
    end
  end

  private

  def leave_params
    permitted = [
      :start_date,
      :end_date
    ]
    params.require(:leave).permit(permitted)
  end

end
