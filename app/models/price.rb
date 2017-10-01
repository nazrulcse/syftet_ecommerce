# require 'localized_number'
class Price < Base
#  include VatPriceCalculation

  acts_as_paranoid

  MAXIMUM_AMOUNT = BigDecimal('99_999_999.99')

  belongs_to :variant, class_name: 'Variant', inverse_of: :prices, touch: true

  before_validation :ensure_currency

  validates :amount, allow_nil: true, numericality: {
                       greater_than_or_equal_to: 0,
                       less_than_or_equal_to: MAXIMUM_AMOUNT
                   }

#  extend DisplayMoney
#  money_methods :amount, :price

  self.whitelisted_ransackable_attributes = ['amount']

  def money
    Money.new(amount || 0, {currency: currency})
  end

  def amount=(amount)
    self[:amount] = amount # LocalizedNumber.parse(amount) TODO: Need to fix
  end

  alias_attribute :price, :amount

  def price_including_vat_for(price_options)
    options = price_options.merge(tax_category: variant.tax_category)
    gross_amount(price, options)
  end

  def display_price_including_vat_for(price_options)
    Money.new(price_including_vat_for(price_options), currency: currency)
  end

# Remove variant default_scope `deleted_at: nil`
  def variant
    Variant.unscoped { super }
  end

  private

  def ensure_currency
    self.currency ||= Config[:currency]
  end
end