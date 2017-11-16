class Api::V1::ReviewsController < Api::ApiBase
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    reviews = Review.where(product_id: params[:product_id])#.page(params[:page]).per(Syftet.config.product_per_page_mobile_api)

    render json: reviews, include:
        [
          {
            user: { only: [:id, :name, :email] }
          }
        ]
  end

  def create
    reviews = current_user.reviews.where(product_id: params[:product_id])
    if reviews.present?
      status = reviews.first.update_attributes(name: 'Tanvir', rating: params[:rating], text: params[:text])
    else
      review = Review.new(name: 'Tanvir', rating: params[:rating], text: params[:text], product_id: params[:product_id], user_id: current_user.id, email: current_user.email)
      status = review.save
    end

    render json: {status: status}
  end

  def update
    review = Review.find_by_id(params[:id])
    status = review.update_attributes(name: 'Tanvir', rating: params[:rating], text: params[:text], product_id: params[:product_id], user_id: current_user.id, email: current_user.email)

    render json: {status: status}
  end

  def destroy
    review = Review.find_by_id(params[:id])
    status = review.destroy ? true : false

    render json: {status: status}
  end
end
