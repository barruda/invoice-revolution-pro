# frozen_string_literal: true

class Invoice < ApplicationRecord
  before_save :default_values

  validates :invoice_id, presence: true, uniqueness: true
  validates :due_date, presence: true
  validates :amount, presence: true

  has_many :chargebacks

  def default_values
    self.status ||= InvoiceStatus::PENDING
  end
end
