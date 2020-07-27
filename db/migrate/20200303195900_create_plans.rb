class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans, id: :uuid do |t|
      t.string    :name,      null: false
      t.integer   :amount,    null: false
      t.string    :currency,  null: false
      t.string    :interval,  null: false
      t.string    :stripe_id, null: false
      t.boolean   :active,    null: false, default: true
    end
  end
end
