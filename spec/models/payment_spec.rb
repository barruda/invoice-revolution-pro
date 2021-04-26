# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:amount) { 120_00 }

  subject do
    described_class.new(amount: amount)
  end

  describe 'validation errors' do
    it 'is not valid without an amount' do
      subject.amount = nil
      expect(subject).to_not be_valid
    end
  end
end
