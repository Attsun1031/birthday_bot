class User < ActiveRecord::Base
  USER_SALT = '_birthday0325'

  attr_accessible :login_failed, :name, :password
  validates_presence_of :name

  def self.authenticate(user_name, password)
    digest = self.create_digest(password)
    user = where(:name => user_name, :password => digest)
    if user != nil and user.length > 0
      return user[0]
    else
      return nil
    end
  end

  protected
  def self.create_digest(password)
    return Digest::SHA1.hexdigest(password + USER_SALT)
  end
end
