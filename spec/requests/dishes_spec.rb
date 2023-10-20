require 'rails_helper'
include JsonWebToken

RSpec.describe "Dishes", type: :request do

  owner = FactoryBot.create(:user, type: 'Owner')
  restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
  category = FactoryBot.create(:category)
  dish = FactoryBot.create(:dish, category_id: category.id, restaurant_id: restaurant.id)
  customer = FactoryBot.create(:user, type: 'Customer')
  user = FactoryBot.create(:user)
  let(:valid_jwt) { jwt_encode(user_id: user.id) }

  describe "GET /restaurants/:restaurant_id/dishes" do
    it "will show only owner specific restaurant dishes" do
      get "/restaurants/#{restaurant.id}/dishes", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will show all dishes specific restaurant dishes" do
      get "/restaurants/#{restaurant.id}/dishes", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /restaurants/:restaurant_id/dishes" do
    it "will create dish in particular restaurant by owner" do
      post "/restaurants/#{restaurant.id}/dishes", params: {name: "Noodles", price: "120.00", category_id: category.id}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:created)
    end
    it "will return error with unprocessable entity" do
      post "/restaurants/#{restaurant.id}/dishes", params: {name: nil}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /restaurants/:restaurant_id/dishes/:dish_id" do
    it "will show specific dish in owner's specific restaurant" do
      get "/restaurants/#{restaurant.id}/dishes/#{dish.id}",headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will show specific dish to customer" do
      get "/restaurants/#{restaurant.id}/dishes/#{dish.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /restaurants/:restaurant_id/dishes/:dish_id" do
    it "will update specific dish in owner's specific restaurant" do
      put "/restaurants/#{restaurant.id}/dishes/#{dish.id}", params: {name: "Chowmin", price: "120.00"}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "return error with unprocessable_entity" do
      put "/restaurants/#{restaurant.id}/dishes/#{dish.id}", params: {name: nil, price: nil}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /restaurants/:restaurant_id/dishes/:dish_id" do
    it "will delete dish " do
      # dish.destroy
      delete "/restaurants/#{restaurant.id}/dishes/#{dish.id}" , headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will return error" do
      delete "/restaurants/#{restaurant.id}/dishes/#{dish.id}" , headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /dishes/search" do
    it "will search dish by name" do
      get "/dishes/search?name=Papita Shake", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: user.id)}" }
    end
    it "will search dish by category" do
      get "/dishes/search?category_id=1", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: user.id)}" }
    end
  end

end
