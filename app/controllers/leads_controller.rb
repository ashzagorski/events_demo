# frozen_string_literal: true

class LeadsController < ApplicationController
  def create
    @lead = Lead.create!(lead_params)

    session[:current_lead_id] = @lead.lead_id

    check_color_qualification
  rescue StandardError => e
    send_reporting(event_name: 'CreateLead', success: false, fail_reason: e.message, meta: { color: current_lead&.color })

    flash[:error] = 'There was an error with your lead, please try again.'
    render :new
  end

  def update
    lead = Lead.find_by(lead_id: current_lead_id)
    lead.update!(lead_params)

    check_state_qualification
  rescue StandardError => e
    send_reporting(event_name: 'UpdateLead', success: false, fail_reason: e.message, meta: { state: current_lead&.state })

    flash[:error] = 'There was an error with your address, please try again.'
    render :edit
  end

  def check_color_qualification
    color_check = CheckColorQualification.new(current_lead.color)
    if color_check.call
      send_reporting(event_name: 'CreateLead', success: true, meta: { color: current_lead.color })
      render :edit
    else
      send_reporting(event_name: 'CreateLead', success: false, fail_reason: color_check.error, meta: { color: current_lead.color })
      render :thank_you
    end
  end

  def check_state_qualification
    state_check = CheckStateQualification.new(current_lead.state)
    if state_check.call
      send_reporting(event_name: 'UpdateLead', success: true, meta: { state: current_lead.state })
      render :info
    else
      send_reporting(event_name: 'UpateLead', success: false, fail_reason: state_check.error, meta: { state: current_lead.state })
      render :thank_you
    end
  end

  private

  def verify_session
    return if current_lead.present?

    flash[:error] = 'Please fill out form.'
    redirect_to new_lead_path
  end

  def lead_params
    params.permit(:email, :first_name, :last_name, :guid, :phone, :color, :state, :zip_code, :city, :street)
  end
end
