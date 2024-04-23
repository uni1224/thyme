class Admin::UsersController < ApplicationController
    before_action :authenticate_admin!
    def index
      @users = User.all
    end
  
    def show
      @user = User.find(params[:id])
      @user_reservations = @user.reservation.where('start_time >= ?', DateTime.current).order(day: :desc)
      @visit_historys = @user.reservation.where('start_time < ?', DateTime.current).where('start_time > ?',
                                                                                          DateTime.current << 12).order(day: :desc)
    end
  
    def edit
      @user = User.find(params[:id])
    end
  
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash[:success] = '会員情報を変更に成功しました'
        redirect_to admin_user_path(@user.id)
      else
        flash[:danger] = '会員情報の更新に失敗しました'
        render :edit
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:first_name, :last_name, :first_name_kana, :birthday, :last_name_kana,
                                   :postal_code, :address, :phone_number, :email, :is_deleted)
    end
end
