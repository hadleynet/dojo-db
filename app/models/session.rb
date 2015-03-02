class Session < ActiveRecord::Base
  belongs_to :style

  def self.days_with_index
    Date::DAYNAMES.zip((0..6).to_a)
  end
  
  def self.day_for(index)
    Date::DAYNAMES[index]
  end
  
  def self.for_day(day_of_week)
    Session.where(day_of_week: day_of_week).order(:am, :hour, :minute) 
  end
  
  def description
    "#{style.description} (#{name})"
  end
  
  def time
    "%d:%02d %s" % [hour, minute, am ? "AM" : "PM"]
  end
end
