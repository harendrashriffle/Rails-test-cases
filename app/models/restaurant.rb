class Restaurant < ApplicationRecord
  belongs_to :owner, foreign_key: 'user_id'
  has_many :dishes, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true #uniqueness: {case_sensitive: false}
  validates :location, presence: true
  validates :status, inclusion: { in: ['Open', 'Closed'] }
end
