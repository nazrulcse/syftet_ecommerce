class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def create
    wishlist = current_user.wishlists.build(product_id: params[:product_id])
    @status = wishlist.save
  end

  def delete

  end

  def index

  end
end