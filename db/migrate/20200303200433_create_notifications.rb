class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.string      :action
      t.string      :target_name_cached
      t.json        :target_path_params
      t.boolean     :read,                  null: false, default: false

      t.references  :sender,                type: :uuid, foreign_key: { to_table: :users }
      t.references  :recipient,             type: :uuid, foreign_key: { to_table: :users }
      t.references  :notifiable,            type: :uuid, polymorphic: true

      t.timestamps
    end
  end
end
