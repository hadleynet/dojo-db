json.array!(@colors) do |color|
  json.extract! color, :id, :id, :description
  json.url color_url(color, format: :json)
end
