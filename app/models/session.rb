class Session < ActiveRecord::Base
  belongs_to :style
  has_many :attendances
  before_destroy :check_for_attendance_against_this_session
  
  def check_for_attendance_against_this_session
    status = true
    if self.attendances.count > 0
      self.errors[:deletion_status] = 'Cannot delete a session that has prior attendances, please deactivate instead'
      status = false
    else
      self.errors[:deletion_status] = 'OK.'
    end
    status
  end

  def self.days_with_index
    Date::DAYNAMES.zip((0..6).to_a)
  end
  
  def self.day_for(index)
    Date::DAYNAMES[index]
  end
  
  def self.for_day(day_of_week)
    Session.where(day_of_week: day_of_week, active: true).order(:am, :hour, :minute) 
  end
  
  def description
    "#{style.description} (#{name})"
  end
  
  def time
    "%d:%02d %s" % [hour, minute, am ? "AM" : "PM"]
  end
end
