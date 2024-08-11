class Api::V1::SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: [:create, :destroy]
    skip_before_action :verify_signed_out_user, only: [:destroy]
  
    def create
      user = User.find_by(email: params[:email])
      if user&.valid_password?(params[:password])
        user.update(device_token: SecureRandom.hex(20))
        render json: { success: 'Login successful.', user: user }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    def destroy
      user = User.find_by(device_token: bearer_token)
      if user
        user.update(device_token: nil)
        render json: { message: 'Logged out successfully' }, status: :ok
      else
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end

    private

    def bearer_token

      pattern = /^Bearer /
      header  = request.headers['Authorization']
      header.gsub(pattern, '') if header && header.match(pattern)
      
    end
  end
  