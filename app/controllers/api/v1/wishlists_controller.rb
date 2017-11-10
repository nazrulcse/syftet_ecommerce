class Api::V1::WishlistsController < Api::ApiBase
  before_action :authenticate_user!

  def index
    wishlists = current_user.wishlists.page(params[:page]).per(Syftet.config.product_per_page_mobile_api)

    response = {
      total_item: wishlists.total_count,
      products: []
    }

    wishlists.each do |wishlist|
      product = wishlist.product
      response[:products] << {
        id: product.id,
        name: product.name,
        avg_rating: product.avg_rating,
        preview_image: product.preview_image_url,
        price: product.price,
        discount_price: product.discount_price,
        is_favourited: true,
        total_on_hand: product.total_on_hand,
        categories: product.taxons.as_json(only: [:id, :name])
      }
    end

    render json: response
  end

  def create
    user = User.find_by_id(params[:user_id])
    wishlist = user.wishlists.find_or_initialize_by(product_id: params[:product_id])
    status = wishlist.save
    render json: {status: status}
  end

  def destroy
    user = User.find_by_id(params[:user_id])
    wishlist = user.wishlists.find_by_id(params[:id])
    wishlist.destroy
    render json: {status: true}
  end
end
