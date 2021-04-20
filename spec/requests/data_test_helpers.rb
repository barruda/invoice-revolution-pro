# frozen_string_literal: true

module DataTestHelpers
  def authenticate_user
    user = create_one_user
    AuthenticateUser.new.process(user)
  end

  def create_one_user(username = 'userauth')
    user = { username: username, password: 'mypassword' }
    User.create(user)
  end

  def create_one_invoice(invoice_id = nil)
    invoice = { invoice_id: invoice_id || 'INVOICE-ID-123123124444', due_date: Time.now, amount: 34_500 }
    Invoice.create(invoice)
  end

  def create_multiple_invoices
    invoice1 = { invoice_id: 'INVOICE-ID-123123123333', due_date: Time.now, amount: 34_500 }
    Invoice.create(invoice1)

    invoice2 = { invoice_id: 'xxx:::Invoice44234234', due_date: DateTime.new(2019, 8, 29),
                 amount: 12_533 }
    Invoice.create(invoice2)

    invoice3 = { invoice_id: '12312312987987', due_date: DateTime.new(2020, 12, 1), amount: 734_999 }
    Invoice.create(invoice3)
  end
end
