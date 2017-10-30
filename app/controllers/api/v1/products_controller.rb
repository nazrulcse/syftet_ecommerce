class Api::V1::ProductsController < Api::ApiBase
  def index
    products = Product.all
    render json: products
  end
end