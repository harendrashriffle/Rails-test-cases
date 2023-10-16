require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'association' do
    it { should have_many(:dishes)}
  end

  describe "validation" do
  it { should validate_uniqueness_of(:name) }
  end
end
