require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe 'association' do
    it { should have_one_attached(:image)}
    it { should have_many(:order_items)}
    it { should have_many(:orders).through(:order_items) }
    it { should have_many(:cart_items)}
    it { should have_many(:carts).through(:cart_items) }
    it { should belong_to(:restaurant) }
    it { should belong_to(:category) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name)}
    it { should validate_uniqueness_of(:name).scoped_to(:restaurant_id) }
    it { should validate_presence_of(:price)}
    it { should validate_numericality_of(:price).is_greater_than(0)}
  end
end
