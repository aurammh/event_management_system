class RegistrationsController < Devise::RegistrationsController

  def create
    super do |user|
      user.update(device_token: SecureRandom.hex(20)) if user.persisted?
    end
  end
  
  private
  def sign_up_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password)
  end
   
end