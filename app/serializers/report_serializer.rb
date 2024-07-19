# frozen_string_literal: true
class ReportSerializer

  def initialize(report)
    @report = report
  end

  def as_json
    {
      uuid: @report.uuid,
      reason: @report.reason,
      reporter_uuid: @report.reporter_uuid,
      history: @report.history.map { |event| { type: event.type}}
    }
    # TODO: uhh fix this please, if we are integrating reports in here
  end
end
