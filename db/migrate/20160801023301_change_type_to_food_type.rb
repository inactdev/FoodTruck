class ChangeTypeToFoodType < ActiveRecord::Migration
  def change
    rename_column :vendors, :type, :food_type
  end
end
