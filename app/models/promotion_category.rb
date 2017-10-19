class PromotionCategory < Base
  validates :name, presence: true
  has_many :promotions
end