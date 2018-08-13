class RemoveCustomerIdFromCharge < ActiveRecord::Migration[5.2]
  def change
    remove_column :charges, :customer_id
  end
end
