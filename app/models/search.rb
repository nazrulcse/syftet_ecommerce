class Search
  attr_accessor :taxon, :terms, :page

  def initialize(params, taxon = nil)
    self.terms = params
    self.taxon = taxon
    self.page = params[:page] || 1
  end

  def result
    if @taxon.present?
      result_object = taxon.products.joins(:variants).joins(:prices)
    else
      result_object = Product.joins(:variants).joins(:prices)
    end

    if terms[:name]
      result_object = result_object.where("lower(name) like '%#{terms[:name]}%'")
    end

    if terms[:min] && terms[:max]
      result_object = result_object.where("prices.amount between #{terms[:min]} and #{terms[:max]}")
    end

    if terms[:color]
      result_object = result_object.where('variants.color_image = ?', terms[:color])
    end
    result_object.order(:created_at).page(page).per(Syftet.config.product_per_page)
  end
end