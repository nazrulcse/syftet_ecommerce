# require 'cancan'
# require_dependency 'spree/core/controller_helpers/strong_parameters'
# TODO: Need to activate all
class BaseController < ApplicationController
  include Core::ControllerHelpers::Auth
  include Core::ControllerHelpers::RespondWith
  # include Core::ControllerHelpers::Common
  # include Core::ControllerHelpers::Search
  include Core::ControllerHelpers::StoreHelper
  include Core::ControllerHelpers::OrderHelper
  include Core::ControllerHelpers::StrongParameters

  respond_to :html
end

# require 'i18n/initializer'
