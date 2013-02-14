class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include ActiveModel::SecurePassword

  field :name
  field :email
  field :password_digest

  has_secure_password

  attr_accessor :current_password

  attr_accessible :password, :password_confirmation, :current_password ,:name ,:email

  index({name: 1},{unique: true})
  index({email: 1},{unique: true})

  validates :name,:email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :format => {:with => /\A\w+\z/, :message => 'only A-Z, a-z, _ allowed'}, :length => {:in => 3..20}
  validates :email, :format => {:with => /\A^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i}
  validates :password, :password_confirmation, :presence => true, :on => :create
  validates :password, :length => {:minimum => 5, :allow_nil => true}
  # validates :current_password, :current_password => {:fields => [:email,:password_digest]}, :on => :update

  def self.authenticate(user)
    self.or({name: user[:login]},{email: user[:login]}).first.try(:authenticate,user[:password])
  end

  def admin?
    Settings.admin_emails.include?(self.email)
  end

  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def self.find_by_remember_token(token)
    user = first :conditions => {:_id => token.split('$').first}
    (user && user.remember_token == token) ? user : nil
  end

  def self.force_create(attributes = nil, options = {}, &block)
    object = new(attributes, options, &block)
    object.save(:validate => false)
    object
  end
end
