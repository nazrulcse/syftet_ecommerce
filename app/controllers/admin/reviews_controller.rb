module Admin
  class ReviewsController < Admin::BaseController
    def update
      @product = Product.friendly.find(params[:product_id])
      @review = @product.reviews.find_by_id(params[:id])
      if @review.update_attributes(review_params.merge(is_approved: true))
        redirect_to admin_product_reviews_path(@product)
      else
        render :edit
      end
    end

    def index
      @product = Product.friendly.find(params[:product_id])
      @reviews = @product.reviews
    end

    def edit
      @product = Product.friendly.find(params[:product_id])
      @review = @product.reviews.find_by_id(params[:id])
    end

    def destroy
      product = Product.friendly.find(params[:product_id])
      review = product.reviews.find_by_id(params[:id])
      review.destroy
      redirect_to admin_product_reviews_url(product)
    end

    private

    def review_params
      params.require(:review).permit!
    end
  end
end