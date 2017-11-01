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
    result_object.order(:created_at).distinct.page(page).per(Syftet.config.product_per_page)
  end

  def find_products
    Product.joins(:variants, :prices).includes(:taxons, :reviews).where(conditions).order(:created_at).distinct.page(page).per(Syftet.config.product_per_page_mobile_api)
  end

  private

  def taxon_conditions
    ['products.taxon_id = ?', taxon.id] unless taxon.blank?
  end
  def new_conditions
    ['products.created_at >= ?', 15.days.ago] if terms['q'] == 'new'
  end
  def discount_conditions
    ['products.promotionable = ?', true] if terms['q'] == 'discount'
  end
  def name_conditions
    ['products.name LIKE ?', "%#{terms[:name]}%"] unless terms[:name].blank?
  end
  def price_conditions
    ['prices.amount between', "#{terms[:min]} and #{terms[:max]}"] if terms[:min] && terms[:max]
  end
  def color_condition
    ['variants.color_image = ?', terms[:color]] unless terms[:color].blank?
  end
  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end
  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end
  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end
  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end