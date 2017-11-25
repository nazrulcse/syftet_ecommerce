class Api::V1::OrdersController < Api::ApiBase
  include Core::TokenGenerator

  def index
    user = User.find_by_id(params[:user_id])
    response = []

    user.orders.each do |order|
      response << {
        id: order.id,
        number: order.number,
        amount: order.amount,
        items: order.line_items.count,
        order_state: order.state,
        payment_state: order.payment_state,
        shipment_state: order.shipment_state,
        created_at: order.created_at
      }
    end

    render json: response
  end

  def detail
    cart = find_cart_by_token_or_user

    result = {}

    if cart.present?
      result = {
        id: cart.id,
        number: cart.number,
        guest_token: cart.guest_token,
        total: cart.total,
        total_item: cart.item_count,
        line_items: []
      }

      cart.line_items.each do |line_item|
        product = line_item.product
        variant = line_item.variant
        result[:line_items] << {
          id: line_item.id,
          product_id: product.id,
          name: product.name,
          price: product.price,
          preview_image: product.preview_image_url,
          color_image: variant.color_image,
          total: line_item.total
        }
      end
    end

    render json: {
      status: cart.present?,
      order: result
    }
  end

  def update
    order = Order.find_by_id(params[:id])
    error = ''
    total = line_item_total = 0.0
    item_count = line_item_count = 0
    if order.present?
      line_item = order.line_items.find_by_id(params[:line_item_id])
      if line_item && params[:quantity]
        add_or_remove_quantity = params[:quantity].to_i
        existing_quantity = line_item.quantity + add_or_remove_quantity
        if add_or_remove_quantity > 0
          line_item = order.contents.add(line_item.variant, add_or_remove_quantity, {})
        elsif add_or_remove_quantity < 0 && existing_quantity > 0
          line_item = order.contents.remove(line_item.variant, add_or_remove_quantity.abs, {})
        else
          error = "Line item quantity can't be 0"
        end
        error = line_item.errors.first unless line_item.save
        line_item_total = line_item.total
        line_item_count = line_item.quantity
      else
        error = 'Line item not found'
      end
      total = order.total
      item_count = order.item_count
    else
      error = 'Order not found'
    end

    render json: {
      status: !error.present?,
      error: error,
      total: total,
      line_item_total: line_item_total,
      item_count: item_count,
      line_item_count: line_item_count
    }
  end

  def populate
    @token = params[:guest_token].present? ? params[:guest_token] : generate_guest_token(model_class = Order)

    @error = nil
    order = current_order(create_order_if_necessary: true)
    variant = Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    size = params[:size]
    options = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        line_item = order.contents.add(variant, quantity, options)
        line_item.size = size
        line_item.save
      rescue ActiveRecord::RecordInvalid => e
        @error = e.record.errors.full_messages.join(', ')
      end
    else
      @error = t(:please_enter_reasonable_quantity)
    end

    render json: {
      status: !@error.present?,
      error: @error,
      token: @token,
      total_item: order.present? ? order.item_count : 0
    }
  end

  def current_cart
    cart = find_cart_by_token_or_user

    if cart.present?
      token = cart.guest_token
      total_item = cart.item_count
    else
      token = ''
      total_item = 0
    end

    render json: {
      status: cart.present?,
      token: token,
      total_item: total_item
    }
  end

  private

  def last_incomplete_order
    @last_incomplete_order ||= current_user.last_incomplete_spree_order
  end

  def current_order(options = {})
    options[:create_order_if_necessary] ||= false

    return @current_order if @current_order

    @current_order = find_order_by_token_or_user(options, true)

    if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
      @current_order = Order.new(current_order_params)
      @current_order.user ||= current_user
      # See issue #3346 for reasons why this line is here
      @current_order.created_by ||= current_user
      @current_order.state ||= 'cart'
      @current_order.save!
    end

    if @current_order
      @current_order.last_ip_address = ip_address
      return @current_order
    end
  end

  def current_order_params
    { currency: current_currency, guest_token: @token, store_id: nil, user_id: params[:user_id] }
  end

  def current_currency
    'bdt'
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

  def find_order_by_token_or_user(options = {}, with_adjustments = false)
    options[:lock] ||= false

    # Find any incomplete orders for the guest_token
    incomplete_orders = Order.incomplete.includes(line_items: [variant: [:images, :option_values, :product]])
    guest_token_order_params = current_order_params.except(:user_id)
    order = if with_adjustments
              incomplete_orders.lock(options[:lock]).find_by(guest_token_order_params)
            else
              incomplete_orders.lock(options[:lock]).find_by(guest_token_order_params)
            end

    # Find any incomplete orders for the current user
    order = last_incomplete_order if order.nil? && current_user

    order
  end

  def ip_address
    request.remote_ip
  end
end
