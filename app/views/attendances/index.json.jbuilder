json.array!(@attendances) do |attendance|
  json.extract! attendance, :id, :date, :person_id, :style_id, :count
  json.url attendance_url(attendance, format: :json)
end
