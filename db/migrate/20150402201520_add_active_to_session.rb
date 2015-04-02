class AddActiveToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :active, :boolean
  end
end
