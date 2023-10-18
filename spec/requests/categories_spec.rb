require 'rails_helper'
include JsonWebToken
RSpec.describe "Categories", type: :request do
  let!(:category){ FactoryBot.create(:category) }
  let!(:user) { FactoryBot.create(:user) }
  let(:valid_jwt) { jwt_encode(user_id: user.id) }
  let!(:owner) {FactoryBot.create(:user, type: 'Owner')}

  describe 'GET /categories' do
    it 'show all category' do
      get "/categories", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /Categories" do
    it 'will create category' do
      # owner = FactoryBot.create(:user, type: 'Owner')
      post '/categories', params:  { name: "indian" },  headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(201)
    end
    it 'return error message with status as unprocessable entity' do
      # owner = FactoryBot.create(:user, type: 'Owner')
      post '/categories', headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /categories/:category_id' do
    it 'shows a category user' do
      get "/categories/#{category.id}", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'shows a category user' do
      category.destroy
      get "/categories/#{category.id}", headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(422)
    end
  end

  describe 'PUT /categories/:category_id' do
    it 'will update category' do
      put "/categories/#{category.id}", params: { name: "maxicon" }, headers: { 'Authorization' =>"Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:ok)
    end
    it 'returns an error with unprocessable_entity' do
      put "/categories/#{category.id}", params: { name: nil }, headers: { 'Authorization' => "Bearer #{jwt_encode(user_id: owner.id)}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

end
