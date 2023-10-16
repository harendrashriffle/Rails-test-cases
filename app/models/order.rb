class Order < ApplicationRecord
  belongs_to :customer, foreign_key: 'user_id'
  has_many :order_items, dependent: :destroy
  has_many :dishes, through: :order_items

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :address, presence: true
end
