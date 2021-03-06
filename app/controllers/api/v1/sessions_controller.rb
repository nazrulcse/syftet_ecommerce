class Api::V1::SessionsController < Api::ApiBase
  before_action :ensure_params_exist

  respond_to :json

  def create
    resource = User.find_for_database_authentication(:email => params[:user_login][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user_login][:password])
      sign_in('user', resource)
      render :json => {:success => true, :auth_token => resource.authentication_token, id: resource.id, :type => resource.user_type, :email => resource.email}
      return
    end
    invalid_login_attempt
  end

  def destroy
    sign_out(resource_name)
  end

  protected

  def ensure_params_exist
    return unless params[:user_login].blank?
    render json: {success: false, message: 'missing user_login parameter'}, status: 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: {success: false, message: 'Error with your login or password'}, status: 401
  end
end