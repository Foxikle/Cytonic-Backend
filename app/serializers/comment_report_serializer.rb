class CommentReportSerializer

  def initialize(report, current_user)
    @report = report
    @current_user = current_user
  end

  def as_json(*)
    {
      id: @report.id,
      resolved: @report.resolved,
      resolved_at: @report.resolved_at,
      created_at: @report.created_at,
      updated_at: @report.updated_at,
      action: @report.action,
      reported_user: SafeUserSerializer.new(@report.user).as_json,
      resolving_user: SafeUserSerializer.new(@report.resolving_user).as_json,
      comment: CommentSerializer.new(@report.comment).as_json,
    }
  end
end
