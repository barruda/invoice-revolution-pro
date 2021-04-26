# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authorize

  def pay
    update_invoice
  end

  def invalidate
    update_invoice InvoiceStatus::INVALID
  end

  private

  def update_invoice(new_status = InvoiceStatus::PAID)
    invoice = InvoiceChangeStatus.new.process params, new_status
    render json: invoice, status: :ok
  rescue Business::NotFoundException
    render json: { errors: 'Could not update - Invoice not found' },
           status: :unprocessable_entity
  end
end
