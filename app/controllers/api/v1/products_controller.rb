class Api::V1::ProductsController < Api::ApiBase
  def index
    products = Search.new(params).result

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
          point: product.credit_point,
          promotion: product.promotionable,
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
        user_review: product.user_review(params[:user_id]),
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
          info: varient.as_json(only: [:id, :sku, :product_id, :color, :color_image, :size]),
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

  def filters
    variants = Variant.all
    render json: {
               categories: Taxon.all.as_json(only: [:id, :name]),
               colors: variants.where.not(color_image: nil).pluck(:color_image).uniq.as_json,
               sizes: variants.where.not(size: '').pluck(:size).uniq.as_json
           }
  end
end
