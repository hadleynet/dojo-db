class Award < ActiveRecord::Base
  belongs_to :person
  belongs_to :rank
  has_one :style, :through => :rank
end
