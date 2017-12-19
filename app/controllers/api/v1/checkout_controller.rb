class Api::V1::CheckoutController < Api::ApiBase

  include Core::ControllerHelpers::StrongParameters

  def update
    error = ''
    @order = cur_order = find_cart_by_token_or_user

    if @order.update_from_params(order_update_params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]
      if @order.next
        cur_order = nil if @order.completed? && !@order.payment_failed?
      else
        error = @order.errors.full_messages.join("\n")
        ######@order.state
      end
    else
      message = []
      @order.errors.each do |key, msg|
        message.push("#{key.to_s.gsub('.', ' ').humanize} #{msg}")
      end
      error = message.join("\n")
    end

    render json: {
      status: !error.present?,
      error: error,
      state: @order.state,
      has_order: cur_order.present?,
      has_failed: params[:failed_id].present?,
      failed_id: params[:failed_id]
    }
  end

  private

  def order_update_params
    params[:order] = {
      email: params[:email],
      use_shipping: params[:use_shipping]
    }

    if params[:state] == 'address'
      params[:order][:ship_address_attributes] = {
        firstname: params[:first_name],
        last_name: params[:last_name],
        address1: params[:address1],
        city: params[:city],
        zipcode: params[:zipcode],
        phone: params[:phone],
        state: params[:state],
        country: params[:country]
      }

      params[:order][:ship_address_attributes][:id] = params[:ship_address_id] if params[:ship_address_id].present?
    end

    params
  end

  def current_order_params
    { currency: current_currency, guest_token: @token, store_id: nil, user_id: params[:user_id] }
  end

  def current_currency
    'gbp'
  end

  def find_cart_by_token_or_user
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