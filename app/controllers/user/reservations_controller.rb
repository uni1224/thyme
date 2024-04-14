class User::ReservationsController < ApplicationController
    before_action :authenticate_user!

    def index
      @reservations = Reservation.all.where('day >= ?', Date.current).where('day < ?',
                                                                            Date.current >> 3).order(day: :desc)
    end
  
    def new
      @reservation = Reservation.new
      @day = params[:day]
      @time = params[:time]
      @start_time = DateTime.parse(@day + ' ' + @time + ' ' + 'JST')
      message = Reservation.check_reservation_day(@day.to_date)
      return unless !!message
  
      redirect_to @reservation, flash: { alert: message }
    end
  
    def show
      @reservation = Reservation.find(params[:id])
    end
  
    def create
      @reservation = Reservation.new(reservation_params)
  
      # 既存の予約を取得
      existing_reservations = Reservation.where(user_id: current_user.id)
  
      # 予約可能かどうかチェック
      if existing_reservations.any? { |existing| existing.start_time > Time.now }
        flash[:danger] = '既存の予約があります。予約時間を過ぎるか、既存の予約をキャンセルしてから新しい予約を取ってください。'
        render :new
      elsif @reservation.save
        flash[:success] = '予約が完了しました'
        redirect_to reservation_path @reservation.id
      else
        flash[:danger] = '予約に失敗しました'
        render :new
      end
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
  
    private
  
    def reservation_params
      params.require(:reservation).permit(:day, :time, :user_id, :start_time)
    end
end
