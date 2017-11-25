class Api::V1::LineItemsController < Api::ApiBase

  def destroy
    error = ''
    total = 0.0
    line_item = LineItem.find_by_id(params[:id])
    if line_item.present?
      begin
        order = line_item.order
        order.contents.remove_line_item(line_item, {})
        total = order.total
      rescue => e
        error = e.message.to_s
      end
    end

    render json: {
      status: !error.present?,
      error: error,
      total: total
    }
  end
end
