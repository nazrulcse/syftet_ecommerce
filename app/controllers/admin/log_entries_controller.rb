module Admin
  class LogEntriesController < Admin::BaseController
    before_action :find_order_and_payment

    def index
      @log_entries = @payment.log_entries
    end


    private

    def find_order_and_payment
      @order = Order.friendly.find(params[:order_id])
      @payment = @order.payments.friendly.find(params[:payment_id])
    end
  end
end