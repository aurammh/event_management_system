class Api::V1::RegistrationsController < Devise::RegistrationsController
    skip_before_action :verify_authenticity_token, only: [:create]
  
    def create
      user = User.new(sign_up_params)
      if user.save
        user.update(device_token: SecureRandom.hex(20))
        render json: { user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
  