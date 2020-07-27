class AddProviderToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :provider_type, :string
    add_column :users, :provider_id, :string

    add_index :users, [:provider_id, :provider_type], unique: true
  end
end
