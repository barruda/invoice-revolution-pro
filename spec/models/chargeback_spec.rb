# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chargeback, type: :model do
  let(:reason) { 'unrecognized payment' }
  let(:amount) { 100_00 }

  subject do
    described_class.new(reason: reason, amount: amount)
  end

  describe 'validation errors' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an username' do
      subject.reason = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.amount = nil
      expect(subject).to_not be_valid
    end
  end
end
