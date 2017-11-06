class Api::V1::HomeController < Api::ApiBase
  def index
    featured_products = Product.featured_products.order(id: :desc).limit(5)
    new_arrivals = Product.new_arrivals.order(id: :desc).limit(5)

    response = {
      featured_products: [],
      new_arrivals: []
    }

    featured_products.each do |product|
      response[:featured_products] << {
        id: product.id,
        name: product.name,
        price: product.price,
        avg_rating: product.avg_rating,
        preview_image: product.preview_image_url
      }
    end

    new_arrivals.each do |product|
      response[:new_arrivals] << {
        id: product.id,
        name: product.name,
        price: product.price,
        avg_rating: product.avg_rating,
        preview_image: product.preview_image_url
      }
    end

    render json: response
  end
end
