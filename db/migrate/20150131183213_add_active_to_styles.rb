class AddActiveToStyles < ActiveRecord::Migration
  def change
    add_column :styles, :active, :boolean
    add_column :styles, :order, :integer
  end
end
