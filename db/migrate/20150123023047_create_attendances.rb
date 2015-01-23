class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.date :date
      t.integer :person_id
      t.integer :style_id
      t.integer :count

      t.timestamps null: false
    end
    add_index :attendances, :date
  end
end
