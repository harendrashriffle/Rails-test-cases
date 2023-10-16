require 'rails_helper'

RSpec.describe "Users", type: :request do

  let!(:user) { FactoryBot.build(:user) }
  let(:valid_jwt) { generate_valid_jwt(user) }

  def generate_valid_jwt(user)
    payload = { user_id: user.id }
    secret_key = Rails.application.secrets.secret_key_base
    JWT.encode(payload, secret_key)
  end
  
  describe 'POST /users' do
    it 'should create a new user' do
      post '/users', params: { name: user.name,email: user.email,password_digest: user.password_digest, type: user.type }
      expect(response).to have_http_status(:ok)
    end
    it 'should returns an error messages' do
      invalid_user_attributes = { name: 'John' }
      post '/users', params: invalid_user_attributes.to_json
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users' do
    it 'show user profile' do
      user.save
      get '/users',  headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /users' do
    it 'update user' do
      user.save
      put '/users',  headers: { 'Authorization' => "Bearer #{valid_jwt}" },params: { name: 'hi'}
      expect(response).to have_http_status(:ok)
    end
    it 'should returns an error messages' do
      user.save
      put '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}"}, params: {name: nil ,email: nil}
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /users' do
    it 'delete user' do
      user.save
      delete '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
    it 'return error message' do
      delete '/users', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /user_login' do
    it 'will login user' do
      user.save
      post '/user_login',params: { user_id: user.id, email: user.email, password_digest: user.password_digest}
      expect(response).to have_http_status(:ok)
    end
     it 'returns message to recheck email & password' do
      post '/user_login',params: { email: '123@gmail.com', password_digest: nil }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'Post /users/forgot_password' do
    it 'forgot password token generate' do
      user.save
      post '/users/forgot_password',params: {email: user.email}
      expect(response).to have_http_status :ok
    end
    it 'not forgfot' do
        post '/users/forgot_password',params: {email: nil}
    end
  end

  describe 'reset' do
    it 'reset password' do
      user.save
      reset_password_token = SecureRandom.hex(10)
      reset_password_sent_at = Time.now
      user.update(reset_password_token: reset_password_token, reset_password_sent_at: reset_password_sent_at)
      post '/users/reset_password', params: {token: reset_password_token, email: user.email}
      expect(response).to have_http_status :ok
    end
     it 'returns unauthorized with invalid credentials' do
       post '/users/reset_password' ,params: {token: nil, email: user.email}
      expect(response).to have_http_status :ok
    end
  end
end
