class ApplicationController < ActionController::API

  protected

  # Validates the token and user and sets the @current_user scope
  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload.first)
      return invalid_authentication
    end

    load_current_user!
    invalid_authentication unless @current_user
  end

  # Validates the refresh token and user and sets the @current_user scope
  def authenticate_refresh_request!
    if !payload || !JsonWebToken.valid_refresh_payload(payload.first)
      return invalid_authentication
    end

    load_current_user!
    invalid_authentication unless @current_user
  end


  # Returns 401 response. To handle malformed / invalid requests.
  def invalid_authentication
    render json: { errors: [{ detail: 'The authentication token was either missing or invalid' }] }, status: :unauthorized
  end

  private

  # Deconstructs the Authorization header and decodes the JWT token.
  def payload
    return @cached_payload if @cached_payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    @cached_payload = JsonWebToken.decode(token)
    @cached_payload
  rescue
    nil
  end

  # Sets the @current_user with the user_id from payload
  def load_current_user!
    @current_user = User.find_by(id: payload[0]['user_id'])
  end

end
