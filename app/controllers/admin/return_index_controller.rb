module Admin
  class ReturnIndexController < BaseController
    respond_to :html, :xml, :json
    
    def return_authorizations
      collection(ReturnAuthorization)
      respond_with(@collection)
    end

    def customer_returns
      collection(CustomerReturn)
      respond_with(@collection)
    end

    private

    def collection(resource)
      return @collection if @collection.present?
      params[:q] ||= {}

      @collection = resource.all
      # @search needs to be defined as this is passed to search_form_for
      @search = @collection.ransack(params[:q])
      per_page = params[:per_page] || Syftet.config.admin_products_per_page
      @collection = @search.result.order(created_at: :desc).page(params[:page]).per(per_page)
    end
  end
end