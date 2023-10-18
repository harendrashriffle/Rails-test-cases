class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :dish

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
