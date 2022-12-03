class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects, dependent: :destroy

  # Before create hook to create default inbox project for user on create
  before_create :build_inbox

  # Return default inbox for user - Only one inbox should exist
  def inbox
    projects.where(inbox: true).first
  end

  # Include users id and email in JWT payload sent after authenticating
  def jwt_payload
    {
      id: id,
      email: email
    }
  end

  private

  def build_inbox
    projects.build(title: 'Inbox', inbox: true)
  end
end
