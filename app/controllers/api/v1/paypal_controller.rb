class Api::V1::PaypalController < Api::ApiBase

  def currency_info
    @order = find_order_by_token_or_user


  end

  def confirm
    order = current_order || raise(ActiveRecord::RecordNotFound)
    order.payments.create!({
                               source: PaypalExpressCheckout.create({
                                                                        token: params[:token],
                                                                        payer_id: params[:PayerID]
                                                                    }),
                               state: 'completed',
                               amount: order.total,
                               payment_method: payment_method
                           })
    order.next
    if order.complete?
      flash.notice = I18n.t(:order_processed_successfully)
      flash[:order_completed] = true
      session[:order_id] = nil
      redirect_to completion_route(order)
    else
      redirect_to checkout_state_path(order.state)
    end
  end

  private

  def find_order_by_token_or_user
    if params[:guest_token].present?
      @token = params[:guest_token]
      guest_token_order_params = current_order_params.except(:user_id)
      incomplete_orders = Order.incomplete.includes(line_items: [variant: [:images, :option_values, :product]])
      cart = incomplete_orders.find_by(guest_token_order_params)
    elsif params[:user_id].present?
      user = User.find_by_id(params[:user_id])
      cart = user.last_incomplete_spree_order
    end

    cart
  end
end