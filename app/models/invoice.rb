# frozen_string_literal: true

class Invoice < ApplicationRecord
  before_save :default_values

  validates :invoice_id, presence: true, uniqueness: { case_sensitive: true }
  validates :due_date, presence: true
  validates :amount, presence: true

  validates :scanned, attached: true, content_type: %w[image/png image/jpg image/jpeg application/pdf],
                      size: { less_than: 5.megabytes, message: 'file must be less than 5MB in size' }

  has_many :chargebacks
  has_one_attached :scanned

  def default_values
    self.status ||= InvoiceStatus::PENDING
  end
end
