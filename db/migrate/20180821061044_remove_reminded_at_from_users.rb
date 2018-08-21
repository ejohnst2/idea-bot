class RemoveRemindedAtFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :reminded_at, :datetime
  end
end
