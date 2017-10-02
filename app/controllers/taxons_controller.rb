class TaxonsController < StoreController
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  helper 'spree/products'

  respond_to :html

  def show
    @taxon = Taxon.includes(:sub_taxons, taxonomy: :top_categories).friendly.find(params[:id])
    @top_categories = @taxon.taxonomy.top_categories.order(created_at: :asc).includes(:sub_taxons)
    return unless @taxon
    @title = @taxon.meta_title
    page = params[:page] || 1
    @products = @taxon.products.includes(:variants, master: [:prices, :images]).order(:created_at).page(page).per(99)
    @featured_category = Spree::Taxon.where(is_featured: true, featured_menu: @taxon.name, taxonomy_id: @taxon.taxonomy_id)
  end

  private

  def accurate_title
    @taxon.try(:seo_title) || super
  end
end