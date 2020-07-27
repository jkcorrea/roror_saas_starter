class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices, id: :uuid do |t|
      t.string      :stripe_id
      t.integer     :amount
      t.string      :currency
      t.string      :number
      t.datetime    :paid_at
      t.text        :lines

      t.references  :account,     foreign_key: true, type: :uuid, null: false

      t.timestamps

      t.index [:stripe_id]
    end
  end
end
