class TopicSerializer
  def initialize (topic)
    @topic = topic
  end

  def as_json(options = {})
    {
      id: @topic.id,
      name: @topic.name
    }
  end
end
