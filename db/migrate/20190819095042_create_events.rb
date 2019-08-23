class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :event_type
      t.date :start_date
      t.date :end_date
      t.date :start_time
      t.date :end_time
      t.text :reccurring_days
      t.timestamps
    end
  end
end