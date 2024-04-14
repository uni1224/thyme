class Admin::ReservationsController < ApplicationController
    before_action :authenticate_admin!
    def index
      @reservations = Reservation.all
    end
  
    def show
      @reservation = Reservation.find(params[:id])
    end
  
    def edit
      @reservation = Reservation.find_by(params[:id])
    end
  
    def update
      @reservation = Reservation.find(params[:id])
      if @reservation.update(reservation_params)
        flash[:success] = '予約を変更しました'
        redirect_to salon_reservation_path(@reservation)
      else
        flash.now[:danger] = '変更に失敗しました'
        render :edit
      end
    end
  
    def destroy
      @reservation = Reservation.find(params[:id])
      if @reservation.destroy
        flash[:success] = '予約を削除しました'
        redirect_to salon_reservations_path(@reservation)
      else
        flash[:success] = '予約の削除に失敗しました'
        render :index
      end
    end
  
    private
  
    def reservation_params
      params.require(:reservation).permit(:day, :time, :user_id, :start_time)
    end
end
