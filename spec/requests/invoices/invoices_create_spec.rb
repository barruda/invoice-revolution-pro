# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/data_test_helpers'

RSpec.configure do |c|
  c.include DataTestHelpers
end

RSpec.describe 'Invoices', type: :request do
  describe 'POST /create' do
    let(:invoice_id) { 'INVOICE-TEST-Invoice Create Spec-009' }
    let(:due_date) { Time.now.to_s }
    let(:amount) { 9_534_900 }

    let(:invoice_data) do
      {
        invoice_id: invoice_id,
        due_date: due_date,
        amount: amount
      }
    end

    context 'when the invoice data is fine and there is no other invoice with the same id registered' do
      before(:each) do
        post '/invoices', params: invoice_data, headers: { 'Authorization' => authenticate_user[:token] }
      end

      it 'should be a successful request with a created status' do
        expect(response).to be_successful
        expect(response).to have_http_status(:created)
      end

      it 'should return an invoice with an id' do
        expect(JSON.parse(response.body)['invoice_id']).to be_truthy
      end
    end

    context 'when there is a invoice with the same id already registered' do
      before(:each) do
        create_one_invoice invoice_id
        post '/invoices', params: invoice_data, headers: { 'Authorization' => authenticate_user[:token] }
      end

      it 'should return an error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
