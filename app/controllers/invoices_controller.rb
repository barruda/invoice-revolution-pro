# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :authorize, except: %i[index download]
  before_action :find_invoice, except: %i[create index]

  def index
    invoices = if params[:status]
                 Invoice.where(status: params[:status])
               else
                 Invoice.all
               end
    if !invoices.empty?
      render json: invoices, status: :ok
    else
      render json: { errors: 'No invoices found' }, status: :not_found
    end
  end

  def show
    render json: @invoice, status: :ok
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      render json: @invoice, status: :created
    else
      render json: { errors: @invoice.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    @invoice = InvoiceUpdate.new.process(invoice_params)
    render json: @invoice, status: :ok
  rescue StandardError
    render json: { errors: 'Could not update Invoice' },
           status: :unprocessable_entity
  end

  def download_invoice
    # TODO: implement me
  end

  def upload_invoice
    # TODO: implement me
  end

  private

  def find_invoice
    @invoice = Invoice.find_by_invoice_id!(params[:invoice_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Invoice not found' }, status: :not_found
  end

  def invoice_params
    params.permit(:invoice_id, :due_date, :amount)
  end
end
