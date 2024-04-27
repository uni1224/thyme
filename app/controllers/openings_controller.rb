class OpeningsController < ApplicationController
    before_action :set_facility

    def new
      @opening = @facility.opening.build
    end
  
    def create
      @opening = @facility.opening.build(opening_hour_params)
      if @opening.save
        redirect_to @facility, notice: 'Opening hour was successfully created.'
      else
        render :new
      end
    end
  
    private
  
    def set_facility
      @facility = Facility.find(params[:facility_id])
    end
  
    def opening_params
      params.require(:opening_hour).permit(:date, :start_time, :end_time)
    end
end
