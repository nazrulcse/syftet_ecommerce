class TaxonsController < StoreController
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  helper 'products'
  layout 'product'
  respond_to :html

  def show
    @taxon = Taxon.friendly.find(params[:id])
    @taxonomy = @taxon.taxonomy
    redirect_to products_path unless @taxon
    @products = Search.new(params, @taxon).result
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  private

  def accurate_title
    @taxon.try(:seo_title) || super
  end
end