require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  # it 'should not valid for same name' do
  #   expect (Restaurant.new(name: 'Mast Nashta',user_id:1,location:'Rajasthan',status: 'Open')).to_not be_valid
  # end

  describe 'association' do
    it { should belong_to(:owner).with_foreign_key('user_id')}
    it { should have_many(:dishes).dependent(:destroy) }
    it { should have_one_attached(:image) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name)}
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:location)}
    it { should validate_inclusion_of(:status).in_array(['Open','Closed'])}
  end
end
