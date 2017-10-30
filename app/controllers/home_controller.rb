class HomeController < BaseController
  def index
    @featured_products = Product.featured_products
    @new_arrivals = Product.new_arrivals
    # OrderMailer.confirm_email(8).deliver_now
  end

  def feedback
    feedback = Feedback.new(feedback_params)
    @status = feedback.save
    respond_to do |format|
      format.js
      format.html {
        flash[:success] = 'Thanks! for your kind feedback.'
        redirect_to root_path
      }
    end
  end

end

# private
# def feedback_params
#   params.require(:feedback).permit(:name, :email, :type, :message, :delivery_report, :product_price, :others, :rate)
# end