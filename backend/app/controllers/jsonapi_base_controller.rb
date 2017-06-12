class JSONAPIBaseController < ApplicationController
  include JSONAPI::ActsAsResourceController

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def context
    { user: @current_user }
  end

  def user_not_authorized
    head :forbidden
  end

  def base_url
    ''
  end

end
