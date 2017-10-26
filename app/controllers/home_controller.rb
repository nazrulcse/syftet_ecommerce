class HomeController < BaseController
  def index
    @featured_products = Product.featured_products
    @new_arrivals = Product.new_arrivals
    # OrderMailer.confirm_email(8).deliver_now
  end
end