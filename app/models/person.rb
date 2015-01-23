class Person < ActiveRecord::Base
  has_many :awards
  has_many :attendances
  has_many :ranks, :through => :awards
end
