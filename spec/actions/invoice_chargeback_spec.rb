# frozen_string_literal: true

require 'rails_helper'

describe InvoiceChargeback do
  let(:invoice_id) { 'someInvoiceId' }
  let(:params) do
    { invoice_id: invoice_id, reason: 'Customer didnt recognized the payment', amount: 9000 }
  end

  let(:invoice_data) do
    { invoice_id: invoice_id, due_date: DateTime.now, amount: 180_00 }
  end

  let(:chargebacks) do
    [Chargeback.new({ amount: 3000, reason: 'Test' }),
     Chargeback.new({ amount: 60_00, reason: 'Test' })]
  end

  let(:registered_invoice) { Invoice.new(invoice_data) }

  subject { described_class.new.process params }

  context 'when there is an invoice registered for the provided id' do
    before do
      allow(Invoice).to receive(:find_by_invoice_id).and_return(registered_invoice)
    end

    context 'and the added chargeback does NOT equal the invoice total amount' do
      before do
        subject
      end

      it { expect(subject.status).to_not eq('CHARGEBACKED') }
    end

    context 'and the added chargeback SURPASS the invoice total amount' do
      context 'and the added chargeback does NOT equal the invoice total amount' do
        before do
          allow(registered_invoice).to receive(:chargebacks).and_return(chargebacks)
          subject
        end

        it { expect(subject.status).to eq('CHARGEBACKED') }
      end
    end
  end

  context 'when there is NOT an invoice registered for the provided id' do
    let(:invoice_id) { 'someInvoiceIdNotValid' }

    it { expect { subject }.to raise_error(Business::InvalidTransactionException) }
  end
end
