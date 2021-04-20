# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:username) { 'myUserName' }
  let(:password) { 'mySecret' }

  subject do
    described_class.new(username: username, password: password)
  end

  context 'when there is no User registered for the id' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an username' do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end
  end

  context 'when there is already an User registered for th' do
    before(:each) do
      described_class.create!(username: username, password: password)
    end

    it 'is not valid because username should be unique' do
      expect(subject).to be_invalid
    end
  end
end
