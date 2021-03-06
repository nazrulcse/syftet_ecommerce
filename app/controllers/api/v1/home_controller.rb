class Api::V1::HomeController < Api::ApiBase

  def index
    featured_products = Product.featured_products.order(id: :desc).limit(5)
    new_arrivals = Product.new_arrivals.order(id: :desc).limit(5)
    discount_products = Product.where(promotionable: true).order(id: :desc).limit(5)
    banners = HomeSlider.all.collect { |banner| banner.image_url(:thumb) }

    response = {
        featured_products: parse_data(featured_products),
        new_arrivals: parse_data(new_arrivals),
        discounts: parse_data(discount_products),
        banners: banners
    }

    render json: response
  end

  private

  def parse_data(product_objects)
    result = []
    product_objects.each do |product|
      result << {
          id: product.id,
          master_id: product.master.id,
          name: product.name,
          price: product.price,
          discount_price: product.discount_price,
          avg_rating: product.avg_rating,
          preview_image: product.preview_image_url,
          promotion: product.promotionable,
          point: product.credit_point,
          is_favourited: product.is_favourite?(params[:user_id]),
      }
    end
    result
  end
end
