class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :event_type
      t.date :start_date
      t.date :end_date
      t.string :start_time
      t.string :end_time
      t.text :reccurring_days
      t.integer :parent_id
      t.timestamps
    end
  end
end