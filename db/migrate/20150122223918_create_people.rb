class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :forename
      t.string :surname
      t.date :birthdate
      t.boolean :active

      t.timestamps null: false
    end
    add_index :people, :active
  end
end
