json.array!(@tests) do |test|
  json.extract! test, :id, :id, :description
  json.url test_url(test, format: :json)
end
