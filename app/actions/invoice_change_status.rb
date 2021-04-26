# frozen_string_literal: true

class InvoiceChangeStatus
  def process(params, new_status = InvoiceStatus::PAID)
    invoice = Invoice.find_by_invoice_id(params[:invoice_id])
    raise Business::NotFoundException unless invoice

    invoice.status = new_status
    invoice.save!
    invoice
  end
end
