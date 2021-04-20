# frozen_string_literal: true

class ChargebacksController < ApplicationController
  before_action :authorize

  def create
    invoice = InvoiceChargeback.new.process chargeback_params
    render json: invoice, status: :ok
  rescue StandardError
    render json: { errors: 'Could not add Chargeback' },
           status: :unprocessable_entity
  end

  private

  def chargeback_params
    params.permit(:invoice_id, :reason, :amount)
  end
end
