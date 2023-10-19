require 'rails_helper'
include JsonWebToken

RSpec.describe "Users", type: :request do

  let!(:user) { FactoryBot.create(:user) }
  let!(:valid_jwt) { generate_valid_jwt(user) }

  def generate_valid_jwt(user)
    payload = { user_id: user.id }
    secret_key = Rails.application.secret_key_base
    JWT.encode(payload, secret_key)
  end

  describe 'POST /user_login' do #user_login API
    it 'will login user' do
      post '/user_login',params: { user_id: user.id, email: user.email, password_digest: user.password_digest}
      expect(response).to have_http_status(:ok)
    end
    it 'returns message to recheck email & password' do
      post '/user_login',params: { email: 'abcd', password_digest: nil }
      expect(response).to have_http_status(:forbidden)
    end
  end
  
  describe 'POST /users' do #user_create API
    it 'should create a new user' do
      post '/users', params: { name: "abc", email: "abc@gmail.com", password_digest: "12345", type: "Customer" }
      expect(response).to have_http_status(:created)
    end
    it 'should returns an error messages' do
      invalid_user_attributes = { name: "a" }
      post '/users', params: invalid_user_attributes.to_json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /users' do #user_show API
    it 'show user profile' do
      get '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'show invalid token for wrong user' do
      get '/users', headers: { 'Authorization' => "Bearer #{"1234"}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /users' do #user_update API
    it 'update user' do
      put '/users',  headers: { 'Authorization' => "Bearer #{valid_jwt}" },params: { name: 'hii'}
      expect(response).to have_http_status(:ok)
    end
    it 'should returns an error messages' do
      put '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}"}, params: { name: nil }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /users' do #user_delete API
    it 'delete user' do
      delete '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'return error message' do
      delete '/users', headers: { 'Authorization' => "Bearer #{"123"}" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /users/forgot_password' do #user_forgot_password API
    it 'message to provide email' do
      post '/users/forgot_password',params: {email: nil}
      expect(response).to have_http_status(:ok)
    end
    it 'user not found' do
      post '/users/forgot_password',params: {email: "1234"}
      expect(response).to have_http_status(:not_found)
    end
    it 'token generate for password' do
      post '/users/forgot_password',params: {email: user.email}
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /users/reset_password' do #user_reset_password API
    it 'email not found' do
      post '/users/reset_password', params: {email: nil}
      expect(response).to have_http_status(:not_found)
    end
    it 'password reset successfully' do
      reset_password_token = SecureRandom.hex(10)
      reset_password_sent_at = Time.now
      user.update(reset_password_token: reset_password_token, reset_password_sent_at: reset_password_sent_at)
      post '/users/reset_password', params: {token: reset_password_token, email: user.email}
      expect(response).to have_http_status(:ok)
    end
     it 'returns unauthorized with invalid credentials' do
       post '/users/reset_password' ,params: {token: " ", email: user.email}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
