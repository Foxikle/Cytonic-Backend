class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :role, :avatar_url, :muted, :muted_at, :muted_until
end
