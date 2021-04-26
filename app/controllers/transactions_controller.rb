# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authorize

  def pay
    invoice = InvoicePay.new.process transaction_params
    render json: invoice, status: :ok
  rescue Business::InvalidTransactionException
    handle_invalid_transaction
  rescue Business::AmountExceedsException
    handle_amount_exceeds
  rescue Business::NotFoundException
    handle_not_found
  end

  def invalidate
    invoice = InvoiceChangeStatus.new.process transaction_params, InvoiceStatus::INVALID
    render json: invoice, status: :ok
  rescue Business::InvalidTransactionException
    handle_invalid_transaction
  rescue Business::NotFoundException
    handle_not_found
  end

  private

  def handle_invalid_transaction
    render json: { errors: 'Could not process - Invalid transaction' },
           status: :unprocessable_entity
  end

  def handle_not_found
    render json: { errors: 'Could not find Invoice' },
           status: :unprocessable_entity
  end

  def handle_amount_exceeds
    render json: { errors: 'You cannot transact an amount superior to invoice total amount' },
           status: :unprocessable_entity
  end

  def transaction_params
    params.permit(:invoice_id, :payment_date, :amount)
  end
end
