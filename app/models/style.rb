class Style < ActiveRecord::Base
  has_many :ranks
  has_many :attendances
  has_many :awards, :through => :ranks
  
  def self.active
    Style.where(active: true).order(:order)
  end
  
  def self.shorin_ryu
    Style.find(2)
  end
end
