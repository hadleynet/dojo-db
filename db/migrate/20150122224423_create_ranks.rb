class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :style_id
      t.string :name
      t.string :translation
      t.integer :order
      t.boolean :active
      t.integer :class_delta
      t.integer :next_rank_test_id
      t.integer :belt_color_id
      t.integer :stripe_color_id
      t.integer :stripe_count

      t.timestamps null: false
    end
  end
end
