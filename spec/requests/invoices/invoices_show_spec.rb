# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/data_test_helpers'

RSpec.configure do |c|
  c.include DataTestHelpers
end

RSpec.describe 'Invoices', type: :request do
  describe 'GET /show' do
    context 'when there is an invoice registered' do
      before(:each) do
        invoice = create_one_invoice
        get '/invoices/' + invoice[:invoice_id],
            headers: { 'Authorization' => authenticate_user[:token] }
      end

      it 'should be a successful request' do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'should return an invoice with an id' do
        expect(JSON.parse(response.body)['invoice_id']).to be_truthy
      end
    end

    context 'when there are no invoices registered for the supplied id' do
      before(:each) do
        get '/invoices/invoice_id_nonexistent', headers: { 'Authorization' => authenticate_user[:token] }
      end

      it 'should return an error with a not found http code' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to be_truthy
      end
    end
  end
end
