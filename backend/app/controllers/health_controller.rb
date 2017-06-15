class HealthController < ApplicationController
  def i_am_alive
    render json: { message: 'JSON Schema Generator says hello' }, status: 200

  end
end
