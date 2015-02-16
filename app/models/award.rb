class Award < ActiveRecord::Base
  belongs_to :person
  belongs_to :rank
  has_one :style, :through => :rank
  
  def self.since(date)
    Award.joins(:person).where("date > :date", {date: date}).order(:date, "people.surname", "people.forename")
  end
  
  def self.for_person_and_style(person, style)
    Award.joins(:rank).where("person_id = :person_id AND ranks.style_id = :style_id", {person_id: person.id, style_id: style.id}).order(:date).reverse_order
  end
end
