# frozen_string_literal: true

class InvoiceChargeback
  def process(params)
    @invoice = Invoice.find_by_invoice_id(params[:invoice_id])
    raise Business::InvalidTransactionException if !@invoice || @invoice.status == InvoiceStatus::CHARGEBACKED

    load_invoice_data params
    raise Business::InsufficientBalanceException if @payments_sum - @chargebacks_sum <= 0

    check_chargeback_conditions(@chargebacks_sum + params[:amount]&.to_i)

    save_chargeback @chargeback
    @invoice
  end

  private

  def chargebacks_amount
    chargebacks = @invoice.chargebacks
    chargeback_amount = 0
    chargebacks&.each do |chargeback|
      chargeback_amount += chargeback.amount
    end
    chargeback_amount
  end

  def check_chargeback_conditions(chargeback_amount)
    if chargeback_amount == @invoice.amount
      @invoice.status = InvoiceStatus::CHARGEBACKED
    elsif chargeback_amount > @invoice.amount
      raise Business::AmountExceedsException
    end
  end

  def payments_total
    payments = @invoice.payments
    payment_amount = 0
    payments&.each do |payment|
      payment_amount += payment.amount
    end
    payment_amount
  end

  def load_invoice_data(params)
    @chargeback = Chargeback.new(params)

    @chargebacks_sum = chargebacks_amount
    @payments_sum = payments_total
  end

  def save_chargeback(chargeback)
    @invoice.chargebacks << chargeback
    @invoice.save!
  end
end
