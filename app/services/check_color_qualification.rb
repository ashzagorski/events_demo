# frozen_string_literal: true

class CheckColorQualification
  attr_accessor :favorite_color, :error

  def self.call(*args)
    new(*args).call
  end

  def initialize(favorite_color)
    @favorite_color = favorite_color
  end

  # state exists, state included in qualified states list, favorite color exists, and present on color service list
  def call
    if favorite_color.present? && favorite_color.match?('blue' || 'red')
      true
    elsif favorite_color.blank?
      self.error = 'missing_color'

      false
    else
      self.error = 'unserviceable_color'

      false
    end
  end
end
