class HomeController < BaseController
  def index
    @featured_products = Product.featured_products
    @new_arrivals = Product.new_arrivals
    @feedbacks = Feedback.order(id: :desc).limit(5)
    # OrderMailer.confirm_email(8).deliver_now
  end

end