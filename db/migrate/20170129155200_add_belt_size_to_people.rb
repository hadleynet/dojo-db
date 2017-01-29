class AddBeltSizeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :belt_size, :string
  end
end
