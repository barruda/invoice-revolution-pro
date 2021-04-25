# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: { case_sensitive: true }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
