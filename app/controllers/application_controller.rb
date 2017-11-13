class ApplicationController < ActionController::Base
  include ActionController::MimeResponds

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
end
