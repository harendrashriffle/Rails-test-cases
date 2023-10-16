require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # subject { User.create(name: "Jack", email: "jsmith@sample.com", password_digest: "123", type: Owner )}

  # it "should valid with valid attributes" do
  #   expect(subject).to be_valid
  # end

  # it "should not valid without a name" do
  #   subject.name = nil
  #   expect(subject).to_not be_valid
  # end

  # it "should not valid without a email" do
  #   subject.email = nil
  #   expect(subject).to_not be_valid
  # end

  # it "should not valid without a password" do
  #   subject.password_digest = nil
  #   expect(subject).to_not be_valid
  # end

  # it "should not valid without a type" do
  #   subject.type = nil
  #   expect(subject).to_not be_valid
  # end

  describe "validation" do
    it { should validate_presence_of(:name)}
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_presence_of(:email)}
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should have_secure_password }
    it { should validate_length_of(:password_digest).is_at_least(4) }
    it { should validate_inclusion_of(:type).in_array(['Customer','Owner'])}
  end
  
end
