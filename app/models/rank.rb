class Rank < ActiveRecord::Base
  belongs_to :style
  belongs_to :belt_color, class_name: "Color", foreign_key: "belt_color_id"
  belongs_to :stripe_color, class_name: "Color", foreign_key: "stripe_color_id"
  belongs_to :next_rank_test, class_name: "Test", foreign_key: "next_rank_test_id"
  has_many :awards
  before_destroy :check_for_people_with_this_rank
  
  def style_and_rank
    "#{style.description}: #{self.name}"
  end

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
  
  def test_needed_from(other)
    test_needed = false
    r = self.prev_rank
    while r do
      if r.next_rank_test != Test::None
        test_needed = true
        break
      end
      break if r == other
      r = r.prev_rank
    end
    test_needed
  end
  
  def next_rank
    higher_ranks = style.ranks.order(:order).select{|rank| rank.active && rank.order>self.order}
    if higher_ranks.length>0
      higher_ranks[0]
    else
      nil
    end
  end
  
  def prev_rank
    lower_ranks = style.ranks.order(:order).select{|rank| rank.active && rank.order<self.order}
    if lower_ranks.length>0
      lower_ranks[-1]
    else
      nil
    end
  end
end
