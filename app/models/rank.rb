class Rank < ActiveRecord::Base
  belongs_to :style
  belongs_to :belt_color, class_name: "Color", foreign_key: "belt_color_id"
  belongs_to :stripe_color, class_name: "Color", foreign_key: "stripe_color_id"
  belongs_to :next_rank_test, class_name: "Test", foreign_key: "next_rank_test_id"
  has_many :awards
  before_destroy :check_for_people_with_this_rank

  def check_for_people_with_this_rank
    status = true
    if self.awards.count > 0
      self.errors[:deletion_status] = 'Cannot delete a rank that is currently held by somebody.'
      status = false
    else
      self.errors[:deletion_status] = 'OK.'
    end
    status
  end
  
  def next_rank
    higher_ranks = style.ranks.order(:order).select{|rank| rank.order>self.order}
    if higher_ranks.length>0
      higher_ranks[0]
    else
      nil
    end
  end
end
