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
  key :current_sign_in_at, Time
  key :remember_created_at, Time
  key :last_sign_in_at, Time
  key :current_sign_in_ip, String
  key :last_sign_in_ip, String
  key :sign_in_count, Integer
  timestamps!
  
  key :roles, Set
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
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