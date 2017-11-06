class Api::V1::ProductsController < Api::ApiBase
  def index
    products = Search.new(params, nil, true).result

    response = {
      total_item: products.total_count,
      products: []
    }

    products.each do |product|
      response[:products] << {
        id: product.id,
        name: product.name,
        avg_rating: product.avg_rating,
        preview_image: product.preview_image_url,
        price: product.price,
        discount_price: product.discount_price,
        is_favourited: product.is_favourite?(params[:user_id]),
        total_on_hand: product.total_on_hand,
        categories: product.taxons.as_json(only: [:id, :name])
      }
    end

    render json: response
  end

  def show
    product = Product.includes(:reviews, :taxons, :wishlists).find_by_id(params[:id])
    reviews = product.reviews

    response = {
      id: product.id,
      name: product.name,
      description: product.description,
      avg_rating: product.avg_rating,
      price: product.price,
      discount_price: product.discount_price,
      is_favourited: product.is_favourite?(params[:user_id]),
      total_on_hand: product.total_on_hand,
      total_review: reviews.count,
      user_review: '',
      images: [],
      rating_detail: reviews.group(:rating).count,
      categories: product.taxons.as_json(only: [:id, :name]),
      varients: []
    }

    product.master_images.each do |image|
      response[:images] << {
        id: image.id,
        photo: image.attachment.url(:product)
      }
    end

    product.variants.each do |varient|
      response[:varients] << {
        info: varient.as_json(only: [:id, :sku, :product_id, :color, :color_image]),
        images: []
      }
      varient.images.order(:id).each do |image|
        response[:varients].last[:images] << {
          id: image.id,
          photo: image.attachment.url(:product)
        }
      end
    end

    render json: response
  end
end
