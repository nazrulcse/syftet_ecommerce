class Api::V1::OrdersController < Api::ApiBase

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

  def show
    user = User.find_by_id(params[:id])
    order = user.orders.find_by_id(params[:id])

    render json: {
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
end