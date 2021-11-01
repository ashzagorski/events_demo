# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :device_id, :remote_ip, :request_id, :lead_id

  public :assign_attributes

  def device_id=(value)
    super
    NewRelic::Agent.add_custom_attributes(device_id: value)
  end

  def remote_ip=(value)
    super
    NewRelic::Agent.add_custom_attributes(remote_ip: value)
  end

  def request_id=(value)
    super
    NewRelic::Agent.add_custom_attributes(request_id: value)
  end

  def lead_id=(value)
    super
    NewRelic::Agent.add_custom_attributes(lead_id: value)
  end
end
