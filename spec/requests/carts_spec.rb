require 'rails_helper'
include JsonWebToken

RSpec.describe "Carts", type: :request do

  customer = FactoryBot.create(:user, type: "Customer")
  owner = FactoryBot.create(:user, type: "Owner")

  describe "POST /carts" do
    it "owner is not authorized" do
      post '/carts', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it "create cart by customer" do
      post '/carts', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:created)
    end
  end
end
