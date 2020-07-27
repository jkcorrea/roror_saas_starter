class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string      :email,                   null: false
      t.string      :first_name
      t.string      :last_name
      t.string      :full_name
      t.string      :encrypted_password
      t.string      :reset_password_token
      t.datetime    :reset_password_sent_at
      t.datetime    :remember_created_at
      t.integer     :sign_in_count,           null: false, default: 0
      t.datetime    :current_sign_in_at
      t.datetime    :last_sign_in_at
      t.string      :current_sign_in_ip
      t.string      :last_sign_in_ip
      t.boolean     :super_admin,             null: false, default: false
      t.string      :invitation_token
      t.datetime    :invitation_created_at
      t.datetime    :invitation_sent_at
      t.datetime    :invitation_accepted_at
      t.integer     :invitation_limit
      t.integer     :invitations_count,       null: false, default: 0

      t.references  :invited_account,         type: :uuid, foreign_key: { to_table: :accounts }
      t.references  :invited_by,              type: :uuid, foreign_key: { to_table: :users }

      t.datetime  :discarded_at
      t.timestamps

      t.index [:email],                   unique: true
      t.index [:reset_password_token],    unique: true
      t.index [:invitation_token],        unique: true
      t.index [:invitations_count]
      t.index [:discarded_at]
    end
  end
end
