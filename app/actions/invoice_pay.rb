# frozen_string_literal: true

class InvoicePay
  def process(params)
    @invoice = Invoice.find_by_invoice_id(params[:invoice_id])

    if !@invoice || @invoice.status == (InvoiceStatus::CHARGEBACKED || InvoiceStatus::PAID)
      raise Business::InvalidTransactionException
    end

    payment = Payment.new(params)
    check_payments_total params[:amount]&.to_i
    save_invoice_payment payment
    payment
  end

  private

  def check_payments_total(transaction_value)
    payments = @invoice.payments
    payment_amount = transaction_value
    payments&.each do |payment|
      payment_amount += payment.amount
    end

    if payment_amount == @invoice.amount
      @invoice.status = InvoiceStatus::PAID
    elsif payment_amount > @invoice.amount
      raise Business::AmountExceedsException
    end
  end

  def save_invoice_payment(payment)
    @invoice.payments << payment
    @invoice.save!
  end
end
