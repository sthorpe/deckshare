json.extract! contact, :id, :email, :user_id, :name, :created_at, :updated_at
json.url contact_url(contact, format: :json)