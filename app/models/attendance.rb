class Attendance < ActiveRecord::Base
  belongs_to :person
  belongs_to :style
  belongs_to :session
end
