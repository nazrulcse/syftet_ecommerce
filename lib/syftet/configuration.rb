module Syftet
  class Configuration
    attr_accessor :currency, :orders_per_page, :show_only_complete_orders_by_default, :admin_product_per_page, :max_level_in_taxons_menu, :admin_products_per_page, :product_per_page, :promotions_per_page,
                  :auto_capture, :properties_per_page, :require_master_price, :product_per_page_mobile_api, :paypal_currency, :currency_symbol

    def initialize
      @currency = 'GBP'
      @orders_per_page = 20
      @show_only_complete_orders_by_default = true
      @admin_product_per_page = 20
      @max_level_in_taxons_menu = 2
      @admin_products_per_page = 20
      @product_per_page = 25
      @product_per_page_mobile_api = 10
      @promotions_per_page = 25
      @auto_capture = true
      @require_master_price = true
      @paypal_currency = 'USD'
      @currency_symbol = '£'
    end
  end
end