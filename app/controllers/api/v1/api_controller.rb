class Api::V1::ApiController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    private
  
    def authenticate_user!
      token = request.headers['Authorization']&.split(' ')&.last
      @current_user = User.find_by(device_token: token)
  
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end
  end
  