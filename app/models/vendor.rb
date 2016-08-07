class Vendor < ActiveRecord::Base
  include Geokit::Geocoders

  belongs_to :owner

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
end