# frozen_string_literal: true

class InvoiceChargeback
  def process(params)
    @invoice = Invoice.find_by_invoice_id(params[:invoice_id])

    if !@invoice || @invoice.status == InvoiceStatus::CHARGEBACKED
      raise Business::InvalidTransactionException unless @invoice
    end

    # TODO: check if the chargeback would surpass the @invoice total amount

    chargeback = Chargeback.new(params)
    @invoice.chargebacks << chargeback

    chargeback_amount = chargebacks_amount

    @invoice.status = InvoiceStatus::CHARGEBACKED if chargeback_amount >= @invoice.amount
    @invoice.save!
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
end
