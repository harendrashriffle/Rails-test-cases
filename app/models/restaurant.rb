class Restaurant < ApplicationRecord
  belongs_to :owner, foreign_key: 'user_id'
  has_many :dishes, dependent: :destroy
  has_one_attached :image

  validates :name, uniqueness: {case_sensitive: false}, presence: true
  validates :location, presence: true
  validates :status, inclusion: { in: ['Open', 'Closed'] }
end
