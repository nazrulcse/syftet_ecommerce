class ApplicationController < ActionController::Base
  include ActionController::MimeResponds

  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user

  end
end
