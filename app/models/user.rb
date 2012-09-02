class User
  include MongoMapper::Document
  safe
  
  key :first_name, String, :required => true
  key :last_name, String
  key :username, String, :unique => true, :required => true
  key :email, String, :required => true
  key :birthday, String
  key :age, Integer
  key :gender, String, :length => 1
  key :encrypted_password, String
  key :password_salt, String
  key :confirmed_at, Time
  key :confirmation_token, String
  key :confirmation_sent_at, Time
  key :unconfirmed_email, String
  
  key :roles, Set
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login
  
  def password_required?
    (!password.blank?) && super
  end
  
  def role?(role)
    self.roles.member?(role.to_s)
  end
  
  protected

  def self.find_for_database_authentication(conditions)
    self.where({ :username => conditions[:login] }).first || self.where({ :email => conditions[:login] }).first
  end       
end