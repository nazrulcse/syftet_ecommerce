module Admin
  class BaseController < ApplicationController
    helper 'admin/navigation'
    helper 'admin/tables'
    layout 'layouts/admin'

    before_action :authorize_admin
    before_action :generate_admin_api_key

    protected

    def action
      params[:action].to_sym
    end

    def authorize_admin
      # if respond_to?(:model_class, true) && model_class
      #   record = model_class
      # else
      #   record = controller_name.to_sym
      # end
      # authorize! :admin, record
      # authorize! action, record
      true
    end

    # Need to generate an API key for a user due to some backend actions
    # requiring authentication to the Spree API
    def generate_admin_api_key
      if (user = current_user) && user.spree_api_key.blank?
        user.generate_spree_api_key!
      end
    end

    def flash_message_for(object, event_sym)
      resource_desc = object.class.model_name.human
      resource_desc += " \"#{object.name}\"" if object.respond_to?(:name) && object.name.present?
      t(event_sym, resource: resource_desc)
    end

    def render_js_for_destroy
      render partial: '/spree/admin/shared/destroy'
    end

    # Index request for JSON needs to pass a CSRF token in order to prevent JSON Hijacking
    def check_json_authenticity
      return unless request.format.js? || request.format.json?
      return unless protect_against_forgery?
      auth_token = params[request_forgery_protection_token]
      unless auth_token && form_authenticity_token == URI.unescape(auth_token)
        raise(ActionController::InvalidAuthenticityToken)
      end
    end

    def config_locale
      Spree::Backend::Config[:locale]
    end

    def can_not_transition_without_customer_info
      unless @order.billing_address.present?
        flash[:notice] = Spree.t(:fill_in_customer_info)
        redirect_to edit_admin_order_customer_url(@order)
      end
    end
  end
end