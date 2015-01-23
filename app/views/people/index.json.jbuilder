json.array!(@people) do |person|
  json.extract! person, :id, :id, :forename, :surname, :birthdate, :active
  json.url person_url(person, format: :json)
end
