# frozen_string_literal: true

class Chargeback < ApplicationRecord
  validates :reason, presence: true
  validates :amount, presence: true
end
