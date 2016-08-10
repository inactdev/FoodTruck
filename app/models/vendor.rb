class Vendor < ActiveRecord::Base
  include Geokit::Geocoders

  ## Associations
  #
  #
  belongs_to :owner

  ## Geokit configs
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  ## Scopes
  #
  #
  scope :by_description, ->(*descriptions) { where(description: [*descriptions]) }
  scope :by_food_type, ->(*food_types) { where(food_type: [*food_types]) }
  scope :by_name, ->(*names) { where(name: [*names]) }
end