class CreateAccountsUsers < ActiveRecord::Migration[6.0]
  def up
    # execute <<-SQL
    #   CREATE TYPE type_role AS ENUM ('admin', 'employee');
    # SQL

    create_table :accounts_users, id: :uuid do |t|
      t.integer     :role,          null: false, default: 0

      t.references  :account,       foreign_key: true, type: :uuid, null: false
      t.references  :user,          foreign_key: true, type: :uuid, null: false

      t.datetime    :discarded_at
      t.timestamps

      t.index [:role]
      t.index [:discarded_at]
      t.index [:account_id, :user_id], unique: true, name: "index_accounts_users_on_account_id_and_user_id"
    end
  end

  def down
    drop_table :accounts_users
    # execute <<-SQL
    #   DROP type type_role;
    # SQL
  end
end
