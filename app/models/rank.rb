class Rank < ActiveRecord::Base
  belongs_to :style
  belongs_to :belt_color, class_name: "Color", foreign_key: "belt_color_id"
  belongs_to :stripe_color, class_name: "Color", foreign_key: "belt_color_id"
  belongs_to :next_rank_test, class_name: "Test", foreign_key: "next_rank_test_id"
  has_many :awards
end
