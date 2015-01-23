json.array!(@awards) do |award|
  json.extract! award, :id, :date, :person_id, :rank_id
  json.url award_url(award, format: :json)
end
