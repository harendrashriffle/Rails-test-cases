require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'association' do
    it {should belong_to(:customer).with_foreign_key(:user_id)}
    it {should have_many(:cart_items).dependent(:destroy)}
    it {should have_many(:dishes).through(:cart_items)}
  end
end
