class User < ActiveRecord::Base
	attr_accessor :password

  validates_confirmation_of :password, :if => :password_changed?
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, :if => :password_changed?

  before_save :hash_new_password, :if => :password_changed?

  def password_changed?
    !@password.blank?
  end

  def self.authenticate(email, password)
    if user = find_by_email(email)
      if BCrypt::Password.new(user.password_hash).is_password? password
        return user
      end
    end
    return nil
  end

  private
  def hash_new_password
    self.password_hash = BCrypt::Password.create(@password)
  end

end
