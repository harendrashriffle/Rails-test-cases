require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'association' do
    it { should have_many(:orders).with_foreign_key('user_id').dependent(:destroy)}
    it { should have_one(:cart).with_foreign_key('user_id').dependent(:destroy)}
  end
end
