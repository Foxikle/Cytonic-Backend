class CategorySerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :topics
end
