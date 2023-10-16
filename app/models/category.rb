class Category < ApplicationRecord
  has_many :dishes

  validates :name, uniqueness: true
end
