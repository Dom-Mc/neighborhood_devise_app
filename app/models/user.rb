class User < ApplicationRecord
  # Include default devise modules. Others available are: :confirmable, :lockable,
  # :omniauthable, :recoverable, :rememberable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable, :validatable

  has_many :posts

  enum role: {
    normal: 0,
    admin: 1
  }

  private

    #default is already set to normal(0) in db, this is simply additional protection.
    def set_default_role
      self.role ||= :normal
    end

end
