# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_id, null: false, index: { unique: true }
      t.datetime :due_date
      t.integer :amount
      t.string :status

      t.timestamps
    end
  end
end
