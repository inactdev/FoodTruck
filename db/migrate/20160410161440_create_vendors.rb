class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :type
      t.text   :description
      t.float  :latitude
      t.float  :longitude

      t.timestamps null: false
    end
  end
end
