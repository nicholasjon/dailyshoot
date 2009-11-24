class User < ActiveRecord::Base
    
  attr_accessible :login, :email, :password
  attr_accessor :password
  
  before_save :set_password_hash_and_salt
  
  validates_uniqueness_of :login, :email
  
  def self.password_hash_for(password, salt)
    Digest::SHA1.hexdigest(salt + password)
  end
  
  def self.authenticate(login, password)
    user = find_by_login(login) || find_by_email(login)
    return nil unless user
    hash = password_hash_for(password, user.password_salt)
    hash == user.password_hash ? user : nil
  end
  
  def to_xml(options={})
    append_to_options(options, :except, [:password_hash, :password_salt])
    super(options)
  end
  
private

  def set_password_hash_and_salt
    if @password
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = self.class.password_hash_for(@password, self.password_salt)
      @password = nil
    end
  end
  
end