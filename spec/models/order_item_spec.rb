require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'association' do
    it { should belong_to(:order)}
    it { should belong_to(:dish)}
  end
end
