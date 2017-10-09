class ApplicationController < ActionController::Base
  include ActionController::MimeResponds

  protect_from_forgery with: :exception

  def authorize! *arge
    true
  end
end
