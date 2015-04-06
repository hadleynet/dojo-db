class Attendance < ActiveRecord::Base
  belongs_to :person
  belongs_to :style
  belongs_to :session
  
  # look for attendance records on specificied date with non-null session ids
  def self.non_session_based?(date)
    a = Attendance.where("date = :date AND session_id IS NULL", {date: date})
    a.length > 0
  end
end
