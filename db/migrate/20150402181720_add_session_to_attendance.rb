class AddSessionToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :session_id, :integer
  end
end
