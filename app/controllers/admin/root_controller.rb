module Admin
  class RootController < Admin::BaseController

    skip_before_action :authorize_admin

    def index
      redirect_to admin_root_redirect_path
    end

    protected

    def admin_root_redirect_path
      admin_orders_path
    end
  end
end
