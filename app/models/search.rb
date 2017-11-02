class Search
  attr_accessor :taxon, :terms, :page, :is_api

  def initialize(params, taxon = nil, is_api = false)
    self.terms = params
    self.taxon = taxon
    self.is_api = is_api
    self.page = params[:page] || 1
  end

  def result
    if @taxon.present?
      result_object = taxon.products.joins(:variants).joins(:prices)
    else
      result_object = Product.joins(:variants).joins(:prices)
    end

    if terms['q'] == 'new'
      result_object = result_object.where("products.created_at >= ?", 15.days.ago)
    end

    if terms['q'] == 'discount'
      result_object = result_object.where('products.promotionable = true')
    end

    if terms[:name]
      result_object = result_object.where("lower(name) like '%#{terms[:name]}%'")
    end

    if terms[:min] && terms[:max]
      result_object = result_object.where("prices.amount between #{terms[:min]} and #{terms[:max]}")
    end

    if terms[:size]
      result_object = result_object.where("variants.size = '#{terms[:size]}'")
    end

    if terms[:color]
      result_object = result_object.where('variants.color_image = ?', terms[:color])
    end

    result_object.order(:created_at).distinct.page(page).per(is_api ? Syftet.config.product_per_page_mobile_api : Syftet.config.product_per_page)
  end

end
