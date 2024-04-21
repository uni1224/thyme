class Admin::HomesController < ApplicationController
    before_action :authenticate_admin!
  def top
    @now = Date.today.month
    @reserve = Reservation.where('created_at >= ?', Date.today)
  end
end
