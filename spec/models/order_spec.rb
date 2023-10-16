require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'association' do
    it { should belong_to(:customer).with_foreign_key('user_id')}
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_many(:dishes).through(:order_items)}
  end

  describe 'validation' do
    it { should validate_presence_of(:price)}
    it { should validate_numericality_of(:price).is_greater_than(0)}
    it { should validate_presence_of(:address)}
  end
end
