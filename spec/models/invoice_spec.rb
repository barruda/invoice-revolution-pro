# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:invoice_id) { 'ID Invoice - Anything' }

  subject do
    described_class.new(invoice_id: invoice_id,
                        due_date: DateTime.now,
                        amount: 450_600)
  end

  context 'when there is no Invoice registered for the id' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an invoice_id' do
      subject.invoice_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without an due_date' do
      subject.due_date = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without an amount' do
      subject.amount = nil
      expect(subject).to_not be_valid
    end
  end

  context 'when there is already an Invoice registered for the id' do
    before(:each) do
      described_class.create!(invoice_id: invoice_id, due_date: DateTime.now,
                              amount: 110_600)
    end

    it 'is not valid because invoice_id should be unique' do
      expect(subject).to be_invalid
    end
  end
end
