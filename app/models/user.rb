class User < ApplicationRecord

  has_secure_password

  validates :name, length: {minimum: 3}, presence: true
  validates :email, uniqueness: {case_sensitive: false}, presence: true
  validates :password_digest, length: {minimum: 4}
  validates :type, inclusion: { in: ['Owner', 'Customer']}

end
