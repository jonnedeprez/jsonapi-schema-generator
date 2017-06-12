require 'json_web_token'

class AuthController < ApplicationController

  def login
    credentials = params.permit(:username, :password)

    user = User.find_by(username: credentials[:username]).try(:authenticate, credentials[:password])

    if user
      access_token = JsonWebToken.encode({ user_id: "#{user.id}" })
      refresh_token = JsonWebToken.encode({ user_id: "#{user.id}", refresh: true })
      render json: { access_token: access_token, refresh_token: refresh_token, user_id: "#{user.id}" }, status: :ok
    else
      render json: { errors: [{ meta: { key: 'username', value: 'User not found' } }] }, status: :unauthorized
    end
  end

end
