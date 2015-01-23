class Style < ActiveRecord::Base
  has_many :ranks
  has_many :attendances
  has_many :awards, :through => :ranks
end
