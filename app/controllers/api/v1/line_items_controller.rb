class Api::V1::LineItemsController < Api::ApiBase

  def destroy
    error = ''
    line_item = LineItem.find_by_id(params[:id])
    if line_item.present?
      begin
        order = line_item.order
        order.contents.remove_line_item(line_item, {})
      rescue => e
        error = e.message.to_s
      end
    end

    render json: {
      status: !error.present?,
      error: error
    }
  end
end
