# frozen_string_literal: true
class ReportSerializer
  include JSONAPI::Serializer
  attributes :uuid, :reason, :history, :reporter_uuid
end
