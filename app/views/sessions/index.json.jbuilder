json.array!(@sessions) do |session|
  json.extract! session, :id, :name, :day_of_week, :style_id, :hour, :minute, :am
  json.url session_url(session, format: :json)
end
