# frozen_string_literal: true
#
class Forums::CategoryImpl
  attr_reader :id, :name, :description, :topics

  def initialize(id, name, description, topics)
    @id = id
    @name = name
    @description = description
    @topics = topics
  end
end
