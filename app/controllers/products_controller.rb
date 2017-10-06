class ProductsController < StoreController
  # before_action :load_product, only: :show
  before_action :load_taxon, only: :index

  rescue_from ActiveRecord::RecordNotFound, :with => :page_not_found
  helper 'taxons'
  layout 'product'

  respond_to :html

  def index
    # @searcher = build_searcher(params.merge(include_images: true))
    # @products = @searcher.retrieve_products
    @products = [] #@products.includes(:possible_promotions) if @products.respond_to?(:includes)
    @taxonomies = Taxonomy.all
  end

  def show
    # @title = accurate_title
    # @taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @product.taxons.first
    # @recommend_products = @product.recommended_products
    # @ratting = rand(4.2..4.8)
    # @ratting = (@ratting * 100) / 5
    # unless @recommend_products.length > 0
    #   @recommend_products = @product.get_recom_products
    # end
    # redirect_if_legacy_path
    @product = Product.last
  end

  def quickview
    @product = Product.last
    respond_to do |format|
      format.js {}
    end
  end

  def keyword_search
    term = params[:keyword]
    search = Spree::Product.solr_search do |s|
      s.keywords params[:keyword]
      s.paginate :page => params[:page] || 1, :per_page => 30
    end

    if is_number?(term)
      product = Spree::Product.find_by_id(term.to_i)
      if product.present?
        redirect_to "/p/#{product.slug}"
      end
    end
    @products = search.results
    @top_categories = get_filter_category(@products)
    @title = "Search result for ‘#{term}''"
  end

  private

  def accurate_title
    if @product
      @product.meta_title.blank? ? @product.name : @product.meta_title
    else
      super
    end
  end

  def load_product
    if try_spree_current_user.try(:has_spree_role?, "admin")
      @products = Product.with_deleted
    else
      @products = Product.active(current_currency)
    end
    @product = @products.includes(:taxons, :brand, :variants, :product_sizes, :recommended_products, master: [:prices, :images]).friendly.find(params[:id])
  end

  def load_taxon
    @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
  end

  def redirect_if_legacy_path
    # If an old id or a numeric id was used to find the record,
    # we should do a 301 redirect that uses the current friendly id.
    if params[:id] != @product.friendly_id
      params.merge!(id: @product.friendly_id)
      return redirect_to url_for(params), status: :moved_permanently
    end
  end

  def is_number? str
    true if Float(str) rescue false
  end

  def get_filter_category(products)
    category = {}
    products.each do |product|
      product.taxons.each do |tax|
        tax_id = tax.id
        if category[tax_id].present?
          category[tax_id] = category[tax_id] + 1
        else
          category[tax_id] = 1
        end
      end
    end
    if category.present?
      top_taxon = category.sort.reverse.first
      @taxon = Spree::Taxon.find_by_id(top_taxon[0])
      @taxon.taxonomy.top_categories.order(created_at: :asc).includes(:sub_taxons)
    end
  end

end