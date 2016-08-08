class Owner < ActiveRecord::Base
  before_create :generate_access_token
  has_many :vendors, :dependent => :destroy

  has_secure_password

  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

  validates :name, :email, :password, presence: true
  validates :name, :email, :access_token, uniqueness: true
  validates :email, format: EMAIL_REGEX

  scope :by_access_token, ->(access_token) { where(access_token: access_token) }
  scope :by_email, ->(email) { where(email: email) }
  scope :by_name, ->(name) { where(name: name) }

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  private

  def generate_access_token
    begin
      self.access_token = self.class.new_token
    end while self.class.exists?(access_token: access_token)
  end
end
