class ChatReport < ApplicationRecord

  def serialize
    ReportSerializer.new(self).serializable_hash
  end


end
