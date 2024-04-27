class Reservation < ApplicationRecord
  belongs_to :user

  validate :date_before_start
  validates :start_time, uniqueness: { message: 'は他のユーザーが予約しています' }
  validate :check_release_date


  def date_before_start
    errors.add(:day, 'は過去の日付は選択できません') if day < Date.current
  end

  def date_current_today
    errors.add(:day, 'は当日は選択できません。予約画面から正しい日付を選択してください。') if day < (Date.current + 1)
  end

  def date_one_month_end
    errors.add(:day, 'は1ヶ月以降の日付は選択できません') if (Date.current >> 1) < day
  end

  def self.check_reservation_day(day)
    if day < Date.current
      '過去の日付は選択できません。正しい日付を選択してください。'
    elsif day < (Date.current + 1)
      '当日は選択できません。正しい日付を選択してください。'
    #elsif (Date.current >> 1) < day
      '1ヶ月以降の日付は選択できません。正しい日付を選択してください。'
    end
  end

  def self.reservations_after_one_month
    reservations = Reservation.all.where('day >= ?', Date.current).where('day < ?', Date.current >> 1).order(day: :desc)
    reservation_data = []
    reservations.each do |reservation|
      reservations_hash = {}
      reservations_hash.merge!(day: reservation.day.strftime('%Y-%m-%d'), time: reservation.time, name: reservation.user.user_name, id: reservation.id)
      reservation_data.push(reservations_hash)
    end
    reservation_data
  end

  # 解放日時を格納するカラムを追加する
  # 解放日時は来月の1日から設定されることを想定して、date 型で定義する
  # 解放日時の初期値は、今月の20日に設定する
  attribute :release_date, :date, default: -> { Date.current.end_of_month.next_month.beginning_of_month + 19.days }

  private

  def check_release_date
    return unless release_date.present?
  
    # 解放日時以降の予約を許可しないようにする
    if day > release_date
      errors.add(:day, "解放日時以降の日付は選択できません。解放日時：#{release_date.strftime('%Y-%m-%d')} 以前の日付を選択してください。")
    end
  
    # 今月の20日から来月の最終日までの範囲に解放日時が含まれているかを検証する
    release_range = (Date.current + 20.days)..(Date.current.end_of_month.next_month)
    errors.add(:release_date, "解放日時は #{release_range.first} から #{release_range.last} の間に設定してください") unless release_range.cover?(release_date)
  end
end
