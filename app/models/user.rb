class User < ActiveRecord::Base
  has_many :authentications, dependent: :destroy
  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password

  validates_presence_of :email
  validates_uniqueness_of :email

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def match_password(login_password="")
      BCrypt::Password.new(password) == login_password
  end

  def self.create_with_auth_and_hash(authentication, auth_hash)
      user = User.new(name: auth_hash["name"], email: auth_hash["extra"]["raw_info"]["email"])
      user.authentications << (authentication)
      user.save!
      return user
  end

  def fb_token
    x = self.authentications.where(:provider => :facebook).first
    return x.token unless x.nil?
  end

  def password_optional?
    true
  end

end
