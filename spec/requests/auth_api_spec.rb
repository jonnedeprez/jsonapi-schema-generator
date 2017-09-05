require 'rails_helper'
require 'json_web_token'

RSpec.describe 'Auth API', type: :request do

  let(:user) { create(:user, password: 'validpassword') }
  let(:access_token) { JsonWebToken.encode({ user_id: user.id})}
  let(:refresh_token) { JsonWebToken.encode({ user_id: user.id, refresh: true })}
  let(:noauth_headers) { { 'Content-Type': 'application/json', ACCEPT: 'application/json' } }
  let(:auth_headers) { noauth_headers.merge({ 'Authorization': "Bearer #{access_token}" }) }
  let(:refresh_auth_headers) { noauth_headers.merge({ 'Authorization': "Bearer #{refresh_token}" }) }

  describe 'POST /auth/login' do
    context 'valid credentials' do
      before do
        post '/auth/login', :params => {
            username: user.username,
            password: 'validpassword'
        }.to_json, :headers => noauth_headers
      end

      it_behaves_like 'http code', 200
    end

    context 'invalid credentials' do
      before do
        post '/auth/login', :params => {
            username: user.username,
            password: 'invalidpassword'
        }.to_json, :headers => noauth_headers
      end

      it_behaves_like 'http code', 401
    end
  end

  describe 'GET /auth/refresh' do
    context 'valid refresh token' do
      before do
        get '/auth/refresh', :headers => refresh_auth_headers
      end

      it_behaves_like 'http code', 200
    end

    context 'normal access token' do
      before do
        get '/auth/refresh', :headers => auth_headers
      end

      it_behaves_like 'http code', 401
    end

    context 'no access token' do
      before do
        get '/auth/refresh', :headers => noauth_headers
      end

      it_behaves_like 'http code', 401
    end
  end


end
