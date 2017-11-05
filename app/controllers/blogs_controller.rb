class BlogsController < BaseController
  layout 'product'

  def index
    @blogs = Blog.all
  end

  def show
    @blog = Blog.friendly.find(params[:id])
  end
end
