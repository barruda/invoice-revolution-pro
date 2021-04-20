# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/data_test_helpers'

RSpec.configure do |c|
  c.include DataTestHelpers
end

RSpec.describe 'Invoices', type: :request do
  describe 'GET /index' do
    context 'when there are multiple invoices registered' do
      before(:each) do
        create_multiple_invoices
        get '/invoices'
      end

      it 'should be a successful request' do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'should return a list of created invoices' do
        expect(JSON.parse(response.body).size).to be 3
      end
    end

    context 'when there are no invoices registered' do
      before(:each) do
        get '/invoices'
      end

      it 'should return an error with a not found http code' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to be_truthy
      end
    end
  end
end
