require 'rails_helper'
require 'json_web_token'

RSpec.describe 'Users API', type: :request do

  let(:user_list) { create_list(:user, 12) }
  let(:user) { create(:user, name: 'Jonne') }
  let(:other_user) { create(:user, name: 'Other user') }
  let(:admin_user) { create(:user, admin: true, name: 'Admin') }

  let(:normal_access_token) { JsonWebToken.encode({user_id: user.id })}
  let(:other_access_token) { JsonWebToken.encode({ user_id: user.id })}
  let(:admin_access_token) { JsonWebToken.encode({ user_id: admin_user.id })}

  let(:noauth_headers) { { 'Content-Type': 'application/vnd.api+json', ACCEPT: 'application/vnd.api+json' } }
  let(:normal_auth_headers) { noauth_headers.merge({'Authorization': "Bearer #{normal_access_token}" }) }
  let(:admin_auth_headers) { noauth_headers.merge({ 'Authorization': "Bearer #{admin_access_token}" }) }

  describe 'GET /api/users' do
    before { user_list }

    context 'unauthenticated' do
      before { get '/api/users' }
      it_behaves_like 'json response with errors key containing', 'The authentication token was either missing or invalid'
      it_behaves_like 'http code', 401
    end

    context 'authenticated' do
      context 'normal user' do
        before { get '/api/users', headers: normal_auth_headers }
        it_behaves_like 'http code', 403
      end

      context 'admin user' do
        before { get '/api/users', headers: admin_auth_headers }

        it 'returns users' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq(13) # page size is 10 by default
        end

        it_behaves_like 'http code', 200
      end
    end
  end

  describe 'POST /api/users' do
    context 'unauthenticated' do
      before do
        post '/api/users', :params => {
            data: {
                type: 'users',
                attributes: {
                    username: 'newuser',
                    name: 'New User',
                    password: 'validpassword'
                }
            }
        }.to_json, :headers => noauth_headers
      end

      it_behaves_like 'json response with errors key containing', 'The authentication token was either missing or invalid'
      it_behaves_like 'http code', 401
    end

    context 'authenticated' do
      context 'normal user' do
        let(:headers) { normal_auth_headers }

        context 'correct params' do
          before do
            post '/api/users', :params => {
                data: {
                    type: 'users',
                    attributes: {
                        username: 'newuser',
                        name: 'New User',
                        password: 'validpassword'
                    }
                }
            }.to_json, :headers => headers
          end

          it_behaves_like 'http code', 403
        end
      end

      context 'admin user' do
        let(:headers) { admin_auth_headers }

        context 'missing name' do
          before do
            post '/api/users', :params => {
                data: {
                    type: 'users',
                    attributes: {
                        username: 'newuser',
                        password: 'validpassword'
                    }
                }
            }.to_json, :headers => headers
          end

          it_behaves_like 'json response with source.pointer', '/data/attributes/name'
          it_behaves_like 'http code', 422
        end

        context 'missing username' do
          before do
            post '/api/users', :params => {
                data: {
                    type: 'users',
                    attributes: {
                        name: 'New User',
                        password: 'validpassword'
                    }
                }
            }.to_json, :headers => headers
          end

          it_behaves_like 'json response with source.pointer', '/data/attributes/username'
          it_behaves_like 'http code', 422
        end

        context 'missing password' do
          before do
            post '/api/users', :params => {
                data: {
                    type: 'users',
                    attributes: {
                        name: 'New User',
                        username: 'newuser'
                    }
                }
            }.to_json, :headers => headers
          end

          it_behaves_like 'json response with source.pointer', '/data/attributes/password'
          it_behaves_like 'http code', 422
        end

        context 'correct params' do
          before do
            post '/api/users', :params => {
                data: {
                    type: 'users',
                    attributes: {
                        username: 'newuser',
                        name: 'New User',
                        password: 'validpassword'
                    }
                }
            }.to_json, :headers => headers
          end

          it 'returns new user' do
            json = JSON.parse(response.body)
            expect(json).not_to be_empty
            expect(json['data']).to include('id')
            expect(json['data']['type']).to eq('users')
            expect(json['data']).to include('attributes')
            expect(json['data']['attributes']['username']).to eq('newuser')
            expect(json['data']['attributes']['admin']).to eq(false)
            expect(json['data']['attributes']).to_not include('password')
          end

          it_behaves_like 'http code', 201
        end
      end
    end
  end

  describe 'GET /api/users/:id' do
    before { user_list }

    context 'unauthenticated' do
      before { get "/api/users/#{user.id}" }
      it_behaves_like 'json response with errors key containing', 'The authentication token was either missing or invalid'
      it_behaves_like 'http code', 401
    end

    context 'authenticated' do
      context 'as normal user' do
        let(:headers) { normal_auth_headers }

        context 'get self' do
          before { get "/api/users/#{user.id}", headers: headers }

          it 'returns existing user by id' do
            json = JSON.parse(response.body)
            expect(json).not_to be_empty
            expect(json['data']).not_to be_empty
            expect(json['data']['attributes']['username']).to eq(user.username)
            expect(json['data']['attributes']['admin']).to eq(false)
          end

          it_behaves_like 'http code', 200
        end

        context 'get other user' do
          before { get "/api/users/#{other_user.id}", headers: headers }
          it_behaves_like 'http code', 403
        end
      end

      context 'as admin user' do
        let(:headers) { admin_auth_headers }

        context 'get existing user' do
          before { get "/api/users/#{user.id}", headers: headers }

          it 'returns existing user by id' do
            json = JSON.parse(response.body)
            expect(json).not_to be_empty
            expect(json['data']).not_to be_empty
            expect(json['data']['attributes']['username']).to eq(user.username)
          end

          it_behaves_like 'http code', 200
        end

        context 'get self' do
          before { get "/api/users/#{admin_user.id}", headers: headers }

          it 'returns self' do
            json = JSON.parse(response.body)
            expect(json).not_to be_empty
            expect(json['data']).not_to be_empty
            expect(json['data']['attributes']['admin']).to eq(true)
          end

          it_behaves_like 'http code', 200
        end

        context 'get inexisting user' do
          before { get "/api/users/#{user.id + 1000}", headers: headers }
          it_behaves_like 'json response with errors key containing', 'could not be found'
          it_behaves_like 'http code', 404
        end
      end
    end
  end

  describe 'PATCH /api/users/:id' do
    context 'unauthenticated' do
      before do
        patch "/api/users/#{user.id}", :params => {
            data: {
                id: "#{user.id}",
                type: 'users',
                attributes: {
                    username: 'updateduser',
                    name: 'Updated User',
                    password: 'updatedpassword'
                }
            }
        }.to_json, :headers => noauth_headers
      end

      it_behaves_like 'json response with errors key containing', 'The authentication token was either missing or invalid'
      it_behaves_like 'http code', 401
    end

    context 'authenticated' do

      context 'as normal user' do
        let(:headers) { normal_auth_headers }

        context 'patch self' do
          context 'patch admin attribute' do
            before do
              patch "/api/users/#{user.id}", :params => {
                  data: {
                      id: "#{user.id}",
                      type: 'users',
                      attributes: {
                          admin: true
                      }
                  }
              }.to_json, :headers => headers
            end

            it_behaves_like 'http code', 400
          end

          context 'patch allowed attributes' do
            before do
              patch "/api/users/#{user.id}", :params => {
                  data: {
                      id: "#{user.id}",
                      type: 'users',
                      attributes: {
                          username: 'updateduser',
                          name: 'Updated User',
                          password: 'updatedpassword'
                      }
                  }
              }.to_json, :headers => headers
            end

            it 'returns patched user' do
              json = JSON.parse(response.body)
              expect(json).not_to be_empty
              expect(json['data']).to include('id')
              expect(json['data']['type']).to eq('users')
              expect(json['data']).to include('attributes')
              expect(json['data']['attributes']['name']).to eq('Updated User')
              expect(json['data']['attributes']['username']).to eq('updateduser')
              expect(json['data']['attributes']).to_not include('password')
            end

            it_behaves_like 'http code', 200
          end
        end

        context 'patch other user' do
          context 'patch allowed attributes' do
            before do
              patch "/api/users/#{other_user.id}", :params => {
                  data: {
                      id: "#{other_user.id}",
                      type: 'users',
                      attributes: {
                          username: 'updateduser',
                          name: 'Updated User',
                          password: 'updatedpassword'
                      }
                  }
              }.to_json, :headers => headers
            end

            it_behaves_like 'http code', 403
          end
        end
      end

      context 'as admin user' do
        let(:headers) { admin_auth_headers }

        context 'empty name' do
          before do
            patch "/api/users/#{user.id}", :params => {
                data: {
                    id: "#{user.id}",
                    type: 'users',
                    attributes: {
                        name: ''
                    }
                }
            }.to_json, :headers => headers
          end

          it_behaves_like 'json response with source.pointer', '/data/attributes/name'
          it_behaves_like 'http code', 422
        end

        context 'correct params' do
          before do
            patch "/api/users/#{user.id}", :params => {
                data: {
                    id: "#{user.id}",
                    type: 'users',
                    attributes: {
                        username: 'updateduser',
                        name: 'Updated User',
                        password: 'updatedpassword',
                        admin: true
                    }
                }
            }.to_json, :headers => headers
          end

          it 'returns updated user' do
            json = JSON.parse(response.body)
            expect(json).not_to be_empty
            expect(json['data']).to include('id')
            expect(json['data']['type']).to eq('users')
            expect(json['data']).to include('attributes')
            expect(json['data']['attributes']['name']).to eq('Updated User')
            expect(json['data']['attributes']['username']).to eq('updateduser')
            expect(json['data']['attributes']['admin']).to eq(true)
            expect(json['data']['attributes']).to_not include('password')
          end

          it_behaves_like 'http code', 200
        end
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    context 'unauthenticated' do
      before { delete "/api/users/#{user.id}" }
      it_behaves_like 'json response with errors key containing', 'The authentication token was either missing or invalid'
      it_behaves_like 'http code', 401
    end

    context 'authenticated' do

      context 'as normal user' do
        let(:headers) { normal_auth_headers }

        context 'existing user' do
          let!(:user_id) { user.id}

          before { delete "/api/users/#{user.id}", headers: headers }

          it_behaves_like 'http code', 403
        end
      end

      context 'as admin user' do
        let(:headers) { admin_auth_headers }

        context 'existing user' do
          let!(:user_id) { user.id}

          before { delete "/api/users/#{user.id}", headers: headers }

          it 'deletes the user' do
            expect{ User.find(user_id) }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it_behaves_like 'http code', 204
        end

        context 'inexisting user' do
          before { delete "/api/users/#{user.id + 1000}", headers: headers }

          it_behaves_like 'json response with errors key containing', 'could not be found'
          it_behaves_like 'http code', 404
        end
      end
    end
  end
end
