# frozen_string_literal: true

class Reports::ChatReportsController < ApplicationController

  def new
    key = params.permit(:key)
    report_params = params.require(:target).permit(:uuid, :reason, history: []) # Permitting history as an array
    sender_params = params.require(:sender).permit(:uuid)
    report_id = SecureRandom.uuid
    #todo: change this to an actual api key system
    if key[:key] == Rails.application.credentials.velocity_api_key
      report = ChatReport.new(
        id: report_id,
        uuid: report_params[:uuid],
        reason: report_params[:reason],
        history: report_params[:history],
        reporter_uuid: sender_params[:uuid]
      )

      if report.save
        render json: { message: 'Successfully created report', report: report.serialize }, status: :created
      else
        render json: { error: 'Failed to create report', errors: report.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: {message: 'Unauthorized.'}, status: :unauthorized
    end
  end
end
