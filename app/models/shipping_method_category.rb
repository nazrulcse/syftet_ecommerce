  class ShippingMethodCategory < Base
    belongs_to :shipping_method, class_name: 'ShippingMethod'
    belongs_to :shipping_category, class_name: 'ShippingCategory', inverse_of: :shipping_method_categories
  end