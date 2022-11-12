class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :tasks, dependent: :destroy
  has_many :projects, dependent: :destroy

  def jwt_payload
    {
      id: id,
      email: email
    }
  end
end
