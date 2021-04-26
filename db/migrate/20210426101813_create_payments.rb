# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.belongs_to :invoice, foreign_key: true

      t.integer :amount
      t.datetime :payment_date

      t.timestamps
    end
  end
end
