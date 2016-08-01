class VendorSerializer < ActiveModel::Serializer
  attributes :id, :name, :food_type, :description, :latitude, :longitude
end
