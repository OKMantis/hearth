class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :rooms, through: :memberships
  has_many :messages, dependent: :destroy

  enum :role, { member: 0, admin: 1 }

  before_save { self.email = email.downcase }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
