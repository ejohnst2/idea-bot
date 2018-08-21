class RemoveRemindersEnabledFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :reminders_enabled, :boolean
  end
end
