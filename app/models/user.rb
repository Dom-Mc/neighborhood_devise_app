class User < ApplicationRecord
  # Include default devise modules. Others available are: :confirmable, :lockable,
  # :omniauthable, :recoverable, :rememberable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable, :validatable#, :omniauthable, :omniauth_providers => [:facebook]


  has_many :posts

  enum role: {
    normal: 0,
    admin: 1
  }

  # NOTE: For OAuth
  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #   end
  # end

  private

    # NOTE: A user's role is automatically set to normal(0) by default in db, this is simply additional protection.
    def set_default_role
      self.role ||= :normal
    end

end
