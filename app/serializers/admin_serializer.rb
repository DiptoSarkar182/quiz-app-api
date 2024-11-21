class AdminSerializer
  include JSONAPI::Serializer
  attributes :id, :full_name, :email, :created_at, :updated_at
end
