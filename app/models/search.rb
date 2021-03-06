class Search
  attr_accessor :taxon, :terms, :page

  def initialize(params, taxon = nil)
    p taxon
    self.terms = params
    self.taxon = taxon
    self.page = params[:page] || 1
  end

  def result
    p '********************************'
    p taxon
    if taxon.present?
      p 'taxon present'
      p taxon
      result_object = taxon.products.joins(:variants).joins(:prices)
    else
      result_object = Product.joins(:variants).joins(:prices)
    end

    if terms['product_type'] == 'recent'
      result_object = result_object.where("products.created_at >= ?", 15.days.ago)
    end

    if terms['product_type'] == 'sale'
      result_object = result_object.where('products.promotionable = true')
    end

    if terms['product_type'] == 'sale'
      result_object = result_object.where('products.promotionable = true')
    end

    if terms['product_type'] == 'featured'
      result_object = result_object.where('products.is_featured = true')
    end

    if terms['product_type'] == 'top_rate'
      result_object = result_object.joins(:reviews).order("reviews.rating DESC")
    end

    if terms[:name].present?
      result_object = result_object.where("lower(name) like '%#{terms[:name]}%'")
    end

    if terms[:min] && terms[:max]
      result_object = result_object.where("prices.amount between #{terms[:min]} and #{terms[:max]}")
    end

    if terms[:size].present?
      result_object = result_object.where("variants.size = '#{terms[:size]}'")
    end

    if terms[:color].present?
      result_object = result_object.where('variants.color_image = ?', terms[:color])
    end

    result_object = result_object.distinct
    result_object = sort_by(result_object)
    result_object.page(page).per(terms['per_page'] || Syftet.config.product_per_page)
  end


  def api_result

    if terms[:taxon].present?
      category = Taxon.find_by_id(terms[:taxon])
      result_object = category.present? ? category.products.joins(:variants).joins(:prices) : Product.joins(:variants).joins(:prices).where(id: 0)
    else
      result_object = Product.joins(:variants).joins(:prices)
    end

    if terms['q'] == 'featured'
      result_object = result_object.where('products.is_featured = true')
      end
    if terms['q'] == 'top_rate'
      result_object = result_object.joins(:reviews).order("reviews.rating DESC")
    end

    if terms['q'] == 'new'
      result_object = result_object.where('products.created_at >= ?', 15.days.ago)
    end

    if terms['q'] == 'discount'
      result_object = result_object.where('products.promotionable = true')
      end
    if terms['q'] == 'sale'
      result_object = result_object.where('products.promotionable = true')
    end

    if terms[:name].present?
      result_object = result_object.where("lower(name) like '%#{terms[:name]}%'")
    end

    if terms[:min].present? && terms[:max].present?
      result_object = result_object.where("prices.amount between #{terms[:min]} and #{terms[:max]}")
    end

    if terms[:size].present?
      result_object = result_object.where("variants.size = '#{terms[:size]}'")
    end

    if terms[:color].present?
      result_object = result_object.where('variants.color_image IN (?)', terms[:color].split(/,/))
    end

    result_object.order(:created_at).distinct.page(page).per(Syftet.config.product_per_page_mobile_api)
  end

  def sort_by(result_object)
    sort_result = result_object
    case terms[:sort]
      when 'price_low'
        sort_result = result_object.reorder('prices.amount')
      when 'price_high'
        sort_result = result_object.reorder('prices.amount desc')
      when 'rating'
      else
        sort_result = result_object.reorder('products.created_at desc')
    end
    sort_result
  end

end
