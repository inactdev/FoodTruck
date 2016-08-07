class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string  :name
      t.string  :email
      t.boolean :admin
      t.string  :password_digest
      t.string  :access_token

      t.timestamps null: false
    end
  end
end
