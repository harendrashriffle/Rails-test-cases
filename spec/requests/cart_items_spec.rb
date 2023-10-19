require 'rails_helper'
include JsonWebToken

RSpec.describe "CartItems", type: :request do

  owner = FactoryBot.create(:user, type: 'Owner')
  restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
  category = FactoryBot.create(:category)
  dish = FactoryBot.create(:dish, category_id: category.id, restaurant_id: restaurant.id)
  customer = FactoryBot.create(:user, type: "Customer")
  cart = FactoryBot.create(:cart, user_id: customer.id)
  cart_items = FactoryBot.create(:cart_item, dish_id: dish.id, cart_id: cart.id)

  describe "GET /cart_items" do
    it "show all cart items if cart has items" do
      get '/cart_items', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "show error if cart has no items" do
      get '/cart_items', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /cart_items" do
    it "will add cart_item to cart" do
      post '/cart_items', params: {quantity: 2, dish_id: dish.id, cart_id: cart.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:created)
    end
    it "return error with unprocessable_entity" do
      post '/cart_items', params: {quantity: nil, dish_id: dish.id, cart_id: cart.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /cart_items/:cart_items_id" do
    it "will update cart_item to cart" do
      put "/cart_items/#{cart_items.id}", params: {quantity: 5, dish_id: dish.id, cart_id: cart.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will add cart_item to cart" do
      put "/cart_items/#{cart_items.id}", params: {quantity: nil, dish_id: dish.id, cart_id: cart.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /cart_items/:cart_items_id" do
    it "will update cart_item to cart" do
      delete "/cart_items/#{cart_items.id}", params: {quantity: 5, dish_id: dish.id, cart_id: cart.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will add cart_item to cart" do
      delete "/cart_items/#{cart_items.id}", params: {quantity: nil, dish_id: dish.id, cart_id: cart.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
