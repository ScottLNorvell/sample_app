# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  # associate user with microposts and mutual destruction!
  # dependent: :destroy == mutual destruction
  has_many :microposts, dependent: :destroy
  # foreign_key somehow connects users to followers. Should grok that later
  # foreign_key is like renaming an inferred relationship
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # establishing relationships through followeds (grammatified to followed_users)
  # followeds changes to followed_users by specifying source: :followed!
  # otherwise we'd say user.followeds and that doen't make sense!
  has_many :followed_users, through: :relationships, source: :followed

  # This sets up reverse relationships through the foreign key "followed_id"
  # foreign_key is like renaming an inferred relationship
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  # Here source could be left out since followers is inferred as referring to follower_id
  # We leave it in for symmetry!                                 
  has_many :followers, through: :reverse_relationships, source: :follower
  before_save { email.downcase! }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  after_validation { self.errors.messages.delete(:password_digest) }

  def feed
    # This is preliminary. See "Following users" for the full implementation
    Micropost.where("user_id = ?", id )
    # essentially the same as def feed/microposts/end
  end

  # looks up and returns bolean if other_user's id is in followed_id
  def following?(other_user)
    # relationships.find_by(followed_id: other_user.id)
    relationships.find_by_followed_id(other_user.id)
  end

  # creates relationship with other_user
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  # find rel by followed_id and .destroy !
  def unfollow!(other_user)
    # relationships.find_by(followed_id: other_user.id).destroy
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
