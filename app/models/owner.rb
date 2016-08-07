class Owner < ActiveRecord::Base
  has_many :vendors, :dependent => :destroy
  has_secure_password

  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

  validates :name, :email, :password, presence: true
  validates :name, :email, :access_token, uniqueness: true
  validates :email, format: EMAIL_REGEX
end
