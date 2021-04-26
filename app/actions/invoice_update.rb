# frozen_string_literal: true

class InvoiceUpdate
  def process(params)
    invoice = Invoice.find_by_invoice_id(params[:invoice_id])

    raise Business::NotFoundException unless invoice

    raise Business::InvalidTransactionException unless params[:amount] && invoice.status != InvoiceStatus::PAID

    invoice.amount = params[:amount]
    invoice.save!
    invoice
  end
end
