class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :name
      t.integer :day_of_week
      t.integer :style_id
      t.integer :hour
      t.integer :minute
      t.boolean :am

      t.timestamps null: false
    end
  end
end
