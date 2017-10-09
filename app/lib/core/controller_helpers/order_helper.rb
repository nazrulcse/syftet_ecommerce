module Core
  module ControllerHelpers
    module OrderHelper
      extend ActiveSupport::Concern

      included do
        before_action :set_current_order

        helper_method :current_order
        helper_method :simple_current_order
      end

      # Used in the link_to_cart helper.
      def simple_current_order

        return @simple_current_order if @simple_current_order

        @simple_current_order = find_order_by_token_or_user

        if @simple_current_order
          @simple_current_order.last_ip_address = ip_address
          return @simple_current_order
        else
          @simple_current_order = Order.new
        end
      end

      # The current incomplete order from the guest_token for use in cart and during checkout
      def current_order(options = {})
        options[:create_order_if_necessary] ||= false

        return @current_order if @current_order

        @current_order = find_order_by_token_or_user(options, true)

        if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
          @current_order = Order.new(current_order_params)
          @current_order.user ||= current_user
          # See issue #3346 for reasons why this line is here
          @current_order.created_by ||= current_user
          @current_order.save(validate: false)
        end

        if @current_order
          @current_order.last_ip_address = ip_address
          return @current_order
        end
      end

      def associate_user
        @order ||= current_order
        if current_user && @order
          @order.associate_user!(current_user) if @order.user.blank? || @order.email.blank?
        end
      end

      def set_current_order
        if current_user && current_order
          current_user.orders.incomplete.where('id != ?', current_order.id).each do |order|
            current_order.merge!(order, current_user)
          end
        end
      end

      def ip_address
        request.remote_ip
      end

      private

      def last_incomplete_order
        @last_incomplete_order ||= current_user.last_incomplete_spree_order
      end

      def current_order_params
        {currency: current_currency, guest_token: cookies[:guest_token], store_id: current_store.id, user_id: current_user.try(:id)}
      end

      def current_currency
        'usd'
      end

      def find_order_by_token_or_user(options={}, with_adjustments = false)
        options[:lock] ||= false

        # Find any incomplete orders for the guest_token
        incomplete_orders = Order.incomplete.includes(line_items: [variant: [:images, :option_values, :product]])
        p incomplete_orders.inspect
        guest_token_order_params = current_order_params.except(:user_id)
        p guest_token_order_params
        order = if with_adjustments
                  incomplete_orders.lock(options[:lock]).find_by(guest_token_order_params)
                else
                  incomplete_orders.lock(options[:lock]).find_by(guest_token_order_params)
                end

        # Find any incomplete orders for the current user
        if order.nil? && current_user
          order = last_incomplete_order
        end

        order
      end

    end
  end
end