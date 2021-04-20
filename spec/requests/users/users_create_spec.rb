# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/data_test_helpers'

RSpec.configure do |c|
  c.include DataTestHelpers
end

RSpec.describe 'Users', type: :request do
  describe 'POST /create' do
    let(:username) { 'myUsername' }
    let(:password) { 'mySuperSecretPassword' }

    let(:user_data) do
      {
        username: username,
        password: password
      }
    end

    context 'when the invoice data is fine and there is no other invoice with the same id registered' do
      before(:each) do
        post '/users', params: user_data
      end

      it 'should be a successful request with a created status' do
        expect(response).to be_successful
        expect(response).to have_http_status(:created)
      end

      it 'should return an user with an id' do
        expect(JSON.parse(response.body)['id']).to be_truthy
      end
    end

    context 'when there is a invoice with the same id already registered' do
      before(:each) do
        create_one_user username
        post '/users', params: user_data
      end

      it 'should return an error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
