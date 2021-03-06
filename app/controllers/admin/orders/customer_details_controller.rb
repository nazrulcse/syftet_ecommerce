module Admin
  module Orders
    class CustomerDetailsController < Admin::BaseController
      before_action :load_order
      before_action :load_user, only: :update, unless: :guest_checkout?

      def show
        edit
        render action: :edit
      end

      def edit
        @order.build_bill_address if @order.bill_address.nil?
        @order.build_ship_address if @order.ship_address.nil?
      end

      def update
        if @order.update_attributes!(order_params)
          @order.associate_user!(@user, @order.email.blank?) unless guest_checkout?
          @order.next unless @order.complete?
          @order.refresh_shipment_rates(ShippingMethod::DISPLAY_ON_FRONT_AND_BACK_END)

          if @order.errors.empty?
            flash[:success] = t('customer_details_updated')
            redirect_to edit_admin_order_url(@order)
          else
            render action: :edit
          end
        else
          render action: :edit
        end
      end

      private

      def order_params
        params.require(:order).permit(
            :email,
            :use_shipping,
            bill_address_attributes: permitted_address_attributes,
            ship_address_attributes: permitted_address_attributes
        )
      end

      def load_order
        @order = Order.includes(:adjustments).friendly.find(params[:order_id])
      end

      def model_class
        Order
      end

      def load_user
        @user = (User.find_by(id: params[:user_id]) ||
            User.find_by(email: order_params[:email]))

        unless @user
          flash.now[:error] = t(:user_not_found)
          render :edit
        end
      end

      def guest_checkout?
        params[:guest_checkout] == 'true'
      end
    end
  end
end