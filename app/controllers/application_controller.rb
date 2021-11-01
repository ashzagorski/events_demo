# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_custom_attributes

  helper_method :current_lead_id

  def current_lead
    return if current_lead_id.blank?

    Lead.find_by(lead_id: current_lead_id)
  end

  def current_lead_id
    session[:current_lead_id]
  end

  def custom_attributes
    { device_id: device_id,
      remote_ip: request.remote_ip,
      request_id: request.request_id,
      lead_id: current_lead&.guid }
  end

  def device_id
    cookies[:device_id] ||= { value: SecureRandom.uuid, expires: 10.years.from_now }
  end

  def send_reporting(event_name:, success:, fail_reason: nil, meta: {})
    data_hash = { success: success }
    data_hash.merge!(fail_reason: fail_reason) if fail_reason.present?
    data_hash.merge!(meta) if meta.present?
    ActiveSupport::Notifications.instrument(event_name, data_hash)
  end

  def set_custom_attributes
    Current.assign_attributes(custom_attributes)
  end
end
