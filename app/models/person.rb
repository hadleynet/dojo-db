class Person < ActiveRecord::Base
  has_many :awards
  has_many :attendances
  has_many :ranks, :through => :awards

  def display_name
    "#{forename} #{surname}"
  end
  
  def styles
    Award.joins(:rank).where("awards.person_id=:person", {person:self.id}).pluck("DISTINCT ranks.style_id")
  end
  
  def self.active
    Person.where(active: true).order(:surname, :forename)
  end
  
  def self.search(search)
    search_condition = "%" + search + "%"
    # SQLite3
    #Person.where('forename LIKE :name OR surname LIKE :name', {name: search_condition})
    # Postgres
    Person.where('forename ILIKE :name OR surname ILIKE :name', {name: search_condition})
  end
  
  def self.all_promotable(style, *test_levels)
    Person.active.select do |p|
      p.ready_for_promotion?(style, *test_levels)
    end
  end
  
  def all_classes
    Attendance.where("person_id = :person_id", {person_id: self.id}).sum(:count)
  end

  def all_classes_since(date)
    Attendance.where("person_id = :person_id and date >= :date", {person_id: self.id, date: date}).sum(:count)
  end
  
  def ready_for_promotion?(style, *test_levels)
    last_promotion = last_promotion(style)
    rank = last_promotion ? last_promotion.rank : style.ranks.first
    classes_since_last_promotion(style) >= rank.class_delta && test_levels.include?(rank.next_rank_test)
  end
  
  def classes_since_last_promotion(style)
    date_of_last_promotion = last_promotion_date(style) || Date.new(1990,1,1)
    Attendance.where("person_id = :person_id AND style_id = :style_id and date > :date", {person_id: self.id, style_id: style.id, date: date_of_last_promotion}).sum(:count)
  end
  
  def last_promotion_date(style)
    latest_promotion_for_style = last_promotion(style)
    if latest_promotion_for_style
      latest_promotion_for_style.date
    else
      nil
    end
  end
  
  def first_promotion
    Award.where({'person': self}).order('awards.date').first
  end
  
  def last_promotion(style)
    Award.joins(:rank).where({'awards.person': self, 'ranks.style': style}).order('awards.date').last
  end
  
  def rank_prior_to(award)
    prior_award_for_style = Award.joins(:rank).where("awards.date < :date AND awards.person_id = :person_id AND ranks.style_id = :style_id", {person_id: self.id, style_id: award.rank.style_id, date: award.date}).order('awards.date').last
    prior_award_for_style ? prior_award_for_style.rank : nil
  end
end
