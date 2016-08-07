class AddIndexesToOwners < ActiveRecord::Migration
  def change
    add_index :owners, :name, unique: true
    add_index :owners, :email, unique: true
    add_index :owners, :access_token, unique: true
  end
end
