class Color < ActiveRecord::Base
  has_many :belts, class_name: "Rank", foreign_key: "belt_color_id"
  has_many :stripes, class_name: "Rank", foreign_key: "stripe_color_id"
  before_destroy :check_for_belts

  def self.white
     self.find_by(description: "White") || self.find_by(description: "white")
  end

  def check_for_belts
    status = true
    if self.belts.count > 0 || self.stripes.count > 0
      self.errors[:deletion_status] = 'Cannot delete a color that is currently used to designate a rank - either a belt or stripe color.'
      status = false
    else
      self.errors[:deletion_status] = 'OK.'
    end
    status
  end
end
