# frozen_string_literal: true

class Payment < ApplicationRecord
  before_save :default_values

  validates :amount, presence: true

  def default_values
    self.payment_date ||= Time.now
  end
end
