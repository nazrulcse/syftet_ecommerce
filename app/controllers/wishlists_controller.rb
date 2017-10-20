class WishlistsController < BaseController
  before_action :authenticate_user!
  layout 'product'

  def create
    wishlist = current_user.wishlists.find_or_initialize_by(product_id: params[:product_id])
    @status = wishlist.save
  end

  def destroy
    wishlist = current_user.wishlists.find_by_id(params[:id])
    wishlist.destroy
  end

  def index
    @wishlists = current_user.wishlists
  end
end