# frozen_string_literal: true

class ChargebacksController < ApplicationController
  before_action :authorize

  def create
    invoice = InvoiceChargeback.new.process chargeback_params
    render json: invoice.to_json(include: %i[chargebacks payments]), status: :ok
  rescue Business::InsufficientBalanceException
    handle_insufficient_payments
  rescue Business::AmountExceedsException
    handle_amount_exceeds
  rescue Business::InvalidTransactionException
    render json: { errors: 'Could not add Chargeback' },
           status: :unprocessable_entity
  end

  private

  def chargeback_params
    params.permit(:invoice_id, :reason, :amount)
  end

  def handle_amount_exceeds
    render json: { errors: 'You cannot chargeback more than the invoice amount' },
           status: :unprocessable_entity
  end

  def handle_insufficient_payments
    render json: { errors: 'You cannot chargeback more than sum of the payments subtracted by the chargebacks' },
           status: :unprocessable_entity
  end
end
