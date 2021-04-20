# frozen_string_literal: true

class CreateChargebacks < ActiveRecord::Migration[6.0]
  def change
    create_table :chargebacks do |t|
      t.belongs_to :invoice, foreign_key: true

      t.integer :amount
      t.string :reason

      t.timestamps
    end
  end
end
