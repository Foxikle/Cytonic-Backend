class SafeUserSerializer
  include JSONAPI::Serializer
  # This one just doesn't hand out user emails, which are not really ideal to share
  attributes :id, :name, :role, :avatar_url
end
