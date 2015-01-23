json.array!(@ranks) do |rank|
  json.extract! rank, :id, :id, :style_id, :name, :translation, :order, :active, :class_delta, :next_rank_test_id, :belt_color_id, :stripe_color_id, :stripe_count
  json.url rank_url(rank, format: :json)
end
