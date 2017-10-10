class OrderPromotion < Base
  belongs_to :order, class_name: 'Order'
  belongs_to :promotion, class_name: 'Promotion'
end