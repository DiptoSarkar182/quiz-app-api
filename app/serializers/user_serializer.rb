class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :full_name, :level, :coins, :gems
end
