class HomeController < BaseController
  def index
    @featured_products = Product.featured_products
    @new_arrivals = Product.new_arrivals
    @feedbacks = Feedback.order(id: :desc).limit(5)
    @blogs = Blog.all.order(:created_at).limit(3)
    @sliders = HomeSlider.all
  end

end