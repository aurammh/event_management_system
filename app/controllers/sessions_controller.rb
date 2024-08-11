class SessionsController < Devise::SessionsController
  
  def create
    user = User.find_by(email: params[:user][:email])
    if user && !user.active
      redirect_to new_user_session_path, alert: 'Your account has been deactivated. Please contact support.'
    else
      self.resource = warden.authenticate(auth_options)
      if self.resource
        user.update(device_token: SecureRandom.hex(20)) if user.persisted?
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)
      else
        redirect_to new_user_session_path, alert: 'Invalid email or password.'
      end
    end
  end
end