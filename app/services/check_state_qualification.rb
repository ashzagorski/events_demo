# frozen_string_literal: true

class CheckStateQualification
  attr_accessor :state, :error

  def self.call(*args)
    new(*args).call
  end

  def initialize(state)
    @state = state
  end

  # state exists, state included in qualified states list, favorite color exists, and present on color service list
  def call
    if state.present? && state.match?('California' || 'Maine')
      true
    elsif state.blank?
      self.error = 'missing_state'

      false
    else
      self.error = 'unserviceable_state'

      false
    end
  end
end
