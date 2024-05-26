class Reports::CommentController < ApplicationController

  # GET /reports/comments/:id

  # GET /reports/comment/
  def index
    unless current_user
      render json: { error: "Not logged in" }, status: 401
    end
    unless current_user.moderator?
      render json: { error: "Access denied" }, status: :forbidden
    end
    if params[:show_resolved].present? && params[:show_resolved]
      @reports = CommentReport.all
    else
      @reports = CommentReport.where(resolved: false) # Only show reports that are not resolved
    end

    serialized_reports = CommentReportSerializer.new(@reports, include: [:user]).serializable_hash
    render json: serialized_reports, status: :ok
  end

  # POST /reports/comments/:id
  def create
    unless current_user
      render json: { error: "Not logged in" }, status: :unauthorized
    end
    unless params[:id].present? || params[:reason].present?
      render json: { error: "Missing parameters" }, status: :bad_request
    end

    @report = CommentReport.new(comment: Comment.find(params[:id]), user: current_user, reason: params[:reason])

    if @report.save
      hash = CommentReportSerializer.new(@report).serializable_hash
      render json: hash, status: :created
    else
      render json: { error: @report.errors }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { message: "Comment " + params[:id].to_s + " does not exist." }, status: :bad_request
  end

  def destroy
    # mark it as resolved #TODO: Notify the reporting user?
    unless current_user
      render json: { error: "Not logged in" }, status: 401
      return
    end
    unless is_allowed?(current_user.role)
      render json: { message: "Forbidden." }, status: :forbidden
      return
    end

    @report = CommentReport.find(params[:id])
    @report.update(resolved: true)
  end

  private

  def is_allowed?(role)
    valid_roles = [Role::OWNER, Role::ADMIN, Role::MODERATOR]
    valid_roles.include?(Role.value_of role)
  end

  def is_allowed_admin?(role)
    valid_roles = [Role::OWNER, Role::ADMIN]
    valid_roles.include?(Role.value_of role)
  end
end