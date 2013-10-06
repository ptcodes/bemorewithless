# encoding: utf-8

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  avatar                 :string(255)
#  username               :string(255)
#  slug                   :string(255)
#  profile                :text
#  provider               :string(255)
#  uid                    :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  language               :string(255)
#

class User < ActiveRecord::Base
  extend FriendlyId
  mount_uploader :avatar, AvatarUploader
  friendly_id :username, use: :slugged

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :avatar, :avatar_cache, :remove_avatar, :username, :profile, :provider, :uid, :first_name, :last_name, :language, :address_attributes

  has_one  :address, as: :addressable, dependent: :destroy
  has_many :gifts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :wishes, dependent: :destroy

  #validates :avatar, integrity: true, processing: true
  validates :username, uniqueness: true, format: {with: /[\w\.\d_]+/,
    message: 'Only letters, digits and underscores allowed' }, length: 3..40
  validates :language, inclusion: {in: %w(en es)}, on: :update

  accepts_nested_attributes_for :address

  delegate :full_address, to: :address

  RESERVED_USERNAMES = ["400", "401", "404", "422", "500", "about", "block",
    "blog", "buy", "contact", "edit", "email", "follower", "friend", "friends",
    "fuck", "bemorewithless", "group", "groups", "help", "home", "jobs",
    "journal", "log", "login", "logout", "mail", "map", "maps", "message", "messages",
    "press", "products", "profile", "root", "secure", "setting",
    "settings", "sudo", "support", "update", "users", "web"]

  LANGUAGES = {'Español' => :es, 'English' => :en}

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if user = User.where(provider: auth.provider, uid: auth.uid).first
      user
    else
      if auth.info.nickname.present?
        nickname = auth.info.nickname
      else
        nickname = auth.extra.raw_info.first_name
      end
      user = User.create(
        first_name: auth.extra.raw_info.first_name,
        last_name: auth.extra.raw_info.last_name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        username: safe_username(nickname),
        password: Devise.friendly_token[0,20],
        address_attributes: {}
      )
      begin
        user_photo = auth.info.image.gsub('square', 'large')
        user.remote_avatar_url = user_photo
        user.save!
      rescue
      end
      user
    end
  end

  def recently_registered?
    created_at < 1.month.ago
  end

  def name
    "#{first_name} #{last_name}"
  end

  def to_s
    username
  end

  def self.safe_username(name)
    if name.empty? || RESERVED_USERNAMES.include?(name) || User.exists?(username: name)
      if first_name.present?
        return "#{first_name.downcase}#{rand(1000)}"
      end
      rand(1000).to_s
    else
      name
    end
  end

end
