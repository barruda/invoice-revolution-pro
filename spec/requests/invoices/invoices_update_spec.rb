# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/data_test_helpers'

RSpec.configure do |c|
  c.include DataTestHelpers
end

RSpec.describe 'Invoices Updates', type: :request do
  describe 'PUT /update' do
    let(:invoice_id) { 'INVOICE-TEST-Invoice' }
    let(:amount) { 7_534_900 }

    let(:invoice_data) do
      {
        amount: amount
      }
    end

    context 'when there is an invoice registered' do
      before(:each) do
        create_one_invoice invoice_id
        put '/invoices/' + invoice_id, params: invoice_data,
                                       headers: { 'Authorization' => authenticate_user[:token] }
      end

      it 'should be a successful request' do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when there are no invoices registered for the supplied id' do
      before(:each) do
        put '/invoices/' + invoice_id, params: invoice_data,
                                       headers: { 'Authorization' => authenticate_user[:token] }
      end

      it 'should return an error with a not found http code' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to be_truthy
      end
    end
  end
end
