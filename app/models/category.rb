class Category < ApplicationRecord
  has_many :dishes

  validates :name, presence: true, uniqueness: true
end
