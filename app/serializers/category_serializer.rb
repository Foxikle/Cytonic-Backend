class CategorySerializer

  def initialize(category)
    @category = category
  end

  def as_json
    {
      id: @category.id,
      name: @category.name,
      description: @category.description,
      topics: @category.topics.map { |topic| TopicSerializer.new(topic).as_json }
    }
  end
end
