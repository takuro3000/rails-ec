# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :name, presence: true, length: { in: 2..50 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
end
