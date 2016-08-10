class AddOwnerIdToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :owner_id, :integer
  end
end
