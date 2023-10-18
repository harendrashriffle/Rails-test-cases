require 'rails_helper'
include JsonWebToken

RSpec.describe "Carts", type: :request do

  customer = FactoryBot.create(:user, type: "Customer")
  owner = FactoryBot.create(:user, type: "Owner")

  describe "POST /carts" do
    it "create cart by customer" do
      post '/carts', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:created)
    end
    it "not create cart" do
      post '/carts', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: nil)}" }
      # byebug
      expect(response.body).to eq("No record found..")
    end
  end
end
