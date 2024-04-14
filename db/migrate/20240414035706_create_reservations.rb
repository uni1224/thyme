class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.integer 'user_id'
      t.datetime 'day'
      t.datetime 'time'
      t.datetime 'start_time'
      t.timestamps
    end
  end
end
