class Forums::TopicsController < ApplicationController
  def show
    topic_id = params[:id]
    topic = Forums::Topic.find(topic_id)

    if topic == Forums::Topic::NONE
      render json: { error: "Topic not found" }, status: :not_found
    else
      render json: {
        id: topic.id,
        name: topic.name,
        is_private: Forums::Topic.is_private?(topic)
      }
    end
  end
end
