# frozen_string_literal: true

ActiveSupport::Notifications.subscribe(/^CreateLead|UpdateLead/) do |name, _start, _finish, _id, payload|
  Current.attributes&.each do |title, attribute|
    payload[title] = attribute if attribute.present?
  end
  ::NewRelic::Agent.record_custom_event(name, payload)
end
