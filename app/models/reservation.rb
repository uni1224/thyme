class Reservation < ApplicationRecord
    belongs_to :user
  
    validate :date_before_start
    validates :start_time, uniqueness: { message: 'は他のユーザーが予約しています' }
  
    def date_before_start
      errors.add(:day, 'は過去の日付は選択できません') if day < Date.current
    end
  
    def date_current_today
      errors.add(:day, 'は当日は選択できません。予約画面から正しい日付を選択してください。') if day < (Date.current + 1)
    end
  
    def date_three_month_end
      errors.add(:day, 'は3ヶ月以降の日付は選択できません') if (Date.current >> 3) < day
    end
  
    def self.check_reservation_day(day)
      if day < Date.current
        '過��の日付は選択できません。正しい日付を選択してください。'
      elsif day < (Date.current + 1)
        '当日は選択できません。正しい日付を選択してください。'
      elsif (Date.current >> 3) < day
        '3ヶ月以降の日付は選択できません。正しい日付を選択してください。'
      end
    end
  
    def self.reservations_after_three_month
      reservations = Reservation.all.where('day >= ?', Date.current).where('day < ?',
                                                                           Date.current >> 3).order(day: :desc)
      reservation_data = []
      reservations.each do |reservation|
        reservations_hash = {}
        reservations_hash.merge!(day: reservation.day.strftime('%Y-%m-%d'), time: reservation.time,
                                 name: reservation.user.user_name, id: reservation.id)
        reservation_data.push(reservations_hash)
      end
      reservation_data
    end
end
