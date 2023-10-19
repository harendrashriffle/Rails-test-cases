require 'rails_helper'
include JsonWebToken

RSpec.describe "Orders", type: :request do

  owner = FactoryBot.create(:user, type: 'Owner')
  restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
  category = FactoryBot.create(:category)
  dish = FactoryBot.create(:dish, category_id: category.id, restaurant_id: restaurant.id)
  customer = FactoryBot.create(:user, type: "Customer")
  cart = FactoryBot.create(:cart, user_id: customer.id)
  cart_items = FactoryBot.create(:cart_item, dish_id: dish.id, cart_id: cart.id)
  order = FactoryBot.create(:order, user_id: customer.id)

  describe "GET /orders" do
    it "owner is not authorized" do
      get '/orders', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it "customer see his order list" do
      get '/orders', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /orders" do
    it "owner is not authorized" do
      post '/orders', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it "order placed by customer" do
      post '/orders', params: {address: "Rajasthan", price: 1000}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:created)
    end
    it "return error message" do
      post '/orders', params: {address: nil}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /orders/:orders_id" do
    it "owner is not authorized" do
      get "/orders/#{order.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it "customer can see his orders" do
      get "/orders/#{order.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "order not found" do
      get "/orders/#{0}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /orders" do
    it "owner is not authorized" do
      delete "/orders/#{order.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it "customer has no order" do
      delete "/orders/#{0}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "order can be deleted under 1 minute" do
      order = FactoryBot.create(:order, user_id: customer.id)
      delete "/orders/#{order.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "order can't be deleted" do
      order = FactoryBot.create(:order, user_id: customer.id, created_at: 1.minute.ago)
      delete "/orders/#{order.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
