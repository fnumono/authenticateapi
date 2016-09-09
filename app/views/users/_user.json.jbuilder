json.extract! user, :id, :email, :password, :auth_token, :created_at, :updated_at
json.url user_url(user, format: :json)