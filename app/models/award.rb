class Award < ActiveRecord::Base
  belongs_to :person
  belongs_to :rank
  has_one :style, :through => :rank
  
  def self.since(date)
    Award.joins(:person).where("date > :date", {date: date}).order(:date, "people.surname", "people.forename")
  end
end
