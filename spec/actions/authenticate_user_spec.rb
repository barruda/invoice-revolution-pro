# frozen_string_literal: true

require 'rails_helper'

describe AuthenticateUser do
  let(:params) do
    { username: 'user-test', password: 'secretTestPassword###' }
  end
  let(:registered_user) { User.new(params) }

  subject { described_class.new.process params }

  context 'when there is a user registered for the username provided' do
    before do
      allow(User).to receive(:find_by_username).and_return(registered_user)
      subject
    end

    it 'should return valid credentials' do
      is_expected.to have_key(:token)
      is_expected.to have_key(:exp)
      is_expected.to have_key(:username)
    end
  end

  context 'when there is no user registered for the username provided' do
    before do
      allow(User).to receive(:find_by_username).and_return(nil)
      subject
    end

    it 'should return without authentication' do
      is_expected.to be_nil
    end
  end
end
