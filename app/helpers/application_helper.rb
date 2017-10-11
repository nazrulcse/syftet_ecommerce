module ApplicationHelper
  # TODO: need to delete this two methods and activate cancan
  def can? *args
    true
  end

  def cannot? *args
    true
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def generate_breadscrumb(text, taxon = nil, product = nil, customs = {})
    html_code = ''
    if taxon.present?
      html_code += "<li> #{link_to taxon.name, ''} </li>"
    end
    if product.present?
      html_code += "<li> #{link_to taxon.name, ''} </li>"
    end
    customs.each do |link_text, link|
      html_code += "<li> #{link_to link_text, link} </li>"
    end
    html_code + "<li> #{t(text.downcase.to_sym)} </li>"
  end

  def get_additional_images(product)
    variant = product.master # Spree::Variant.where(product_id: product.id, is_master: true).first
    variant.images.order(:id) # Spree::Asset.where(viewable_id: variant.id).order(:id)
  end

  def format_general_name(name)
    name
  end

  def get_price_for_product(price)
    price
  end

  def current_currency
    'usd'
  end

  def get_all_variant(product)
    product.variants.includes(:prices) # Spree::Variant.where(product_id: product_id, is_master: false)
  end

  def get_varient_price(variant)
    amount = variant.prices.first.amount # Spree::Price.where(variant_id: variant_id).first.amount
    "#{map_currency}#{(amount * money_conversion_rate).round(2)}"
  end

  def money_conversion_rate
    1
  end

  def map_currency
    'USD'
  end

  def variant_color_image_option(image_link)
    if image_link.present?
      if image_link.length == 6
        "background: ##{image_link};"
      else
        "background: url(#{image_link}) center center;"
      end
    else
      'Default'
    end
  end

  def check_country(country)
    country == 'BD'
  end

  def get_image_object(product)
    variant = product.master # Spree::Variant.where(product_id: product.id, is_master: true).first
    variant.present? ? variant.images.order(:id).first : ''
  end

  def get_image_link(product, image)
    image.present? && image.attachment.present? ? image.attachment.url(:product) : small_image(product)
  end

  def get_zoom_image_link(image)
    image.present? && image.attachment.present? ? image.attachment.url(:large) : "#{image.attachment.url}"
  end

  def get_active_class(action, menu_action)
    action == menu_action ? 'active' : ''
  end

  def mini_image(variant, size = 50)
    image_url = 'assets/not_available.png'
    if variant.present?
      image_url = variant.images.present? ? variant.images.order(:id).first.attachment.url(:small) : ''
    end
    image_tag(image_url, style: "width: #{50}px")
  end

  def product_preview_image(product)
    if product.master_images.present?
      image = product.master_images.last
      image_tag(image.attachment.url(:product), class: 'image-hover product-image')
    else
      ''
    end
  end

  def product_thumb_image(product)
    if product.master_images.present?
      image = product.master_images.last
      image_tag(image.attachment.url, class: 'single-image-fluid')
    else
      ''
    end
  end

  def wishlist_link(product)
    wishlist = current_user.present? ? current_user.wishlists.find_by_product_id(product) : nil
    if wishlist.present?
      raw "<i class='fa fa-heart' style='color: #fcc030;' title='added to wishlist'></i>"
    else
      link_to product_wishlists_path(product), remote: true, method: :post do
        raw '<i class="fa fa-heart-o"></i>'
      end
    end
  end

  def categories(product)
    tags = []
    product.taxons.each do |taxon|
      tags.push("<span> #{link_to taxon.name, categories_path(taxon)} </span>")
    end
    tags.join(' | ')
  end

  def color_filters(taxon = nil)
    if taxon
      product_ids = taxon.products.map(&:id)
      variants = Variant.joins(:product).where(product_id: product_ids)
    else
      variants = Variant.all.limit(10)
    end
    variants.map(&:color_image).compact
  end

  # Order

  def line_item_count
    current_order.present? ? current_order.line_items.count : 0
  end

  def amount_with_currency(amount, currency='$')
    "#{currency}#{amount}"
  end

end
