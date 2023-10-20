require 'rails_helper'
include JsonWebToken

RSpec.describe "Restaurants", type: :request do

  let!(:owner) {FactoryBot.create(:user, type: 'Owner')}
  let!(:customer) {FactoryBot.create(:user, type: 'Customer')}
  let!(:restaurant){ FactoryBot.create(:restaurant, user_id: owner.id) }
  let!(:user) { FactoryBot.create(:user) }

  describe 'GET /restaurants' do #index API
    it "will show specific restaurante by owner" do
      owner = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      get "/restaurants", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will show restaurant search by name" do
      user = FactoryBot.create(:user)
      get "/restaurants?name=Nashta Point 2", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will show restaurant search by status" do
      user = FactoryBot.create(:user)
      get "/restaurants?status=Open", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will show restaurant search by location" do
      user = FactoryBot.create(:user)
      get "/restaurants?location=Rajasthan", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
    end

  end


  describe 'POST /restaurants' do
    it "customer not authorized" do
      post '/restaurants',params: {name: "Syayaji", status: "Open", location: "Indore"}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:unauthorized)
    end
    it "will create restaurant" do
      post '/restaurants', params: {name: "Syayaji", status: "Open", location: "Indore"}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(201)
    end
    it "will return error with unprocessable entity" do
      post '/restaurants', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /restaurants/:restaurant_id' do
    it "will show specific restaurante by owner" do
      owner = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      get "/restaurants/#{restaurant.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will show specific restaurant bu customer" do
      customer = FactoryBot.create(:user, type: 'Customer')
      get "/restaurants/#{restaurant.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: customer.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /restaurants/:restaurant_id' do
    it "will update specific restaurant" do
      owner = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      put "/restaurants/#{restaurant.id}", params: {status: "Open"}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it "will return error message with unprocessable_entity" do
      owner = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      put "/restaurants/#{restaurant.id}", params: {status: nil}, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

   describe 'DELETE /restaurants/:restaurant_id' do
    it "will update specific restaurant" do
      owner = FactoryBot.create(:user, type: 'Owner')
      restaurant = FactoryBot.create(:restaurant, user_id: owner.id)
      delete "/restaurants/#{restaurant.id}", headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
