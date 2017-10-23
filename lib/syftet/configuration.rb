module Syftet
  class Configuration
    attr_accessor :currency, :orders_per_page, :show_only_complete_orders_by_default, :admin_product_per_page, :max_level_in_taxons_menu, :admin_products_per_page, :product_per_page, :promotions_per_page,
                  :auto_capture

    def initialize
      @currency = 'USD'
      @orders_per_page = 20
      @show_only_complete_orders_by_default = false
      @admin_product_per_page = 20
      @max_level_in_taxons_menu = 2
      @admin_products_per_page = 20
      @product_per_page = 25
      @promotions_per_page = 25
      @auto_capture = true
    end
  end
end