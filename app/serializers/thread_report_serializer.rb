class ThreadReportSerializer

  def initialize (report, current_user)
    @report = report
    @current_user = current_user
  end

  def as_json(*)
    {
      resolved: @report.resolved,
      resolved_at: @report.resolved_at,
      created_at: @report.created_at,
      updated_at: @report.updated_at,
      action: @report.action,
      reason: @report.reason,
      user: SafeUserSerializer.new(@report.user).serializable_hash,
      resolving_user: resolving_user,
      thread: ThreadSerializer.new(@report.thread, @current_user).as_json
    }
  end

  private

  def resolving_user
    if @report.resolved && @report.resolving_user_id.present?
      SafeUserSerializer.new(User.find(@report.resolving_user_id)).as_json
    else
      nil
    end
  end
end
