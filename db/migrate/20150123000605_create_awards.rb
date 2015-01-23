class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.date :date
      t.integer :person_id
      t.integer :rank_id

      t.timestamps null: false
    end
    add_index :awards, :date
    add_index :awards, :person_id
  end
end
