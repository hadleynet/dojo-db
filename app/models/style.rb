class Style < ActiveRecord::Base
  has_many :ranks
  has_many :attendances
  has_many :awards, :through => :ranks
  
  def self.active
    Style.where(active: true).order(:order)
  end
end
