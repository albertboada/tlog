json.array!(@logs) do |log|
  json.extract! log, :id, :start, :finish, :comment, :project_id
  json.url log_url(log, format: :json)
end
