class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string      :name,                    null: false
      t.string      :subdomain,               null: false, limit: 40
      t.string      :stripe_customer_id
      t.string      :stripe_subscription_id
      t.string      :card_last4,              limit: 4
      t.integer     :card_exp_month,          limit: 2
      t.integer     :card_exp_year
      t.string      :card_type
      t.datetime    :current_period_end
      t.boolean     :trialing,                null: false, default: true
      t.boolean     :past_due,                null: false, default: false
      t.boolean     :unpaid,                  null: false, default: false
      t.boolean     :cancelled,               null: false, default: false
      t.integer     :active_users_count,      null: false, default: 0

      t.references  :plan,                    foreign_key: true, type: :uuid

      t.datetime  :discarded_at
      t.timestamps

      t.index [:subdomain], unique: true
      t.index [:name]
      t.index [:past_due]
      t.index [:unpaid]
      t.index [:cancelled]
      t.index [:discarded_at]
      t.index [:current_period_end]
    end

  end
end
