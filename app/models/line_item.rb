class LineItem < Base
  before_validation :ensure_valid_quantity

  with_options inverse_of: :line_items do
    belongs_to :order, class_name: "Order", touch: true
    belongs_to :variant, class_name: "Variant"
  end
  belongs_to :tax_category, class_name: "TaxCategory"

  has_one :product, through: :variant

  has_many :adjustments, as: :adjustable, dependent: :destroy
  has_many :inventory_units, inverse_of: :line_item

  before_validation :copy_price
  # before_validation :copy_tax_category

  validates :variant, presence: true
  validates :quantity, numericality: {only_integer: true, message: I18n.t('validation.must_be_int')}
  validates :price, numericality: true

  # validates_with Stock::AvailabilityValidator TODO: Need to activate this
  validate :ensure_proper_currency

  before_destroy :update_inventory
  before_destroy :destroy_inventory_units

  after_save :update_inventory
  after_save :update_adjustments

  # after_create :update_tax_charge

  delegate :name, :description, :sku, :should_track_inventory?, :product, to: :variant
  # delegate :tax_zone, to: :order TODO: Not consider tax this time

  attr_accessor :target_shipment

  self.whitelisted_ransackable_associations = ['variant']
  self.whitelisted_ransackable_attributes = ['variant_id']

  def copy_price
    if variant
      update_price if price.nil?
      self.cost_price = variant.cost_price if cost_price.nil?
      self.currency = variant.currency if currency.nil?
    end
  end

  def update_price
    # self.price = variant.price_including_vat_for(tax_zone: tax_zone) # TODO: Not consider vat this time
  end

  def copy_tax_category
    if variant
      self.tax_category = variant.tax_category
    end
  end

  extend DisplayMoney
  money_methods :amount, :subtotal, :discounted_amount, :final_amount, :total, :price

  alias single_money display_price
  alias single_display_amount display_price

  def amount
    price * quantity
  end

  def credit_point
    variant.credit_point
  end

  alias subtotal amount

  def taxable_amount
    amount + taxable_adjustment_total
  end

  alias discounted_money display_discounted_amount
  alias_method :discounted_amount, :taxable_amount

  def final_amount
    amount + adjustment_total
  end

  alias total final_amount
  alias money display_total

  def invalid_quantity_check
    warn "`invalid_quantity_check` is deprecated. Use private `ensure_valid_quantity` instead."
    ensure_valid_quantity
  end

  def sufficient_stock?
    Stock::Quantifier.new(variant).can_supply? quantity
  end

  def insufficient_stock?
    !sufficient_stock?
  end

  def options=(options = {})
    return unless options.present?

    opts = options.dup # we will be deleting from the hash, so leave the caller's copy intact

    currency = opts.delete(:currency) || order.try(:currency)

    update_price_from_modifier(currency, opts)
    assign_attributes opts
  end

  private

  def ensure_valid_quantity
    self.quantity = 0 if quantity.nil? || quantity < 0
  end

  def update_price_from_modifier(currency, opts)
    if currency
      self.currency = currency
      self.price = variant.price_in(currency).amount || 0 +
          variant.price_modifier_amount_in(currency, opts) || 0
    else
      self.price = variant.price +
          variant.price_modifier_amount(opts)
    end
  end

  def update_inventory
    if (changed? || target_shipment.present?) && order.has_checkout_step?("delivery")
      OrderInventory.new(order, self).verify(target_shipment) # TODO: need to activate this
    end
  end

  def destroy_inventory_units
    inventory_units.destroy_all
  end

  def update_adjustments
    if quantity_changed?
      recalculate_adjustments
      update_tax_charge # Called to ensure pre_tax_amount is updated.
    end
  end

  def recalculate_adjustments
    Adjustable::AdjustmentsUpdater.update(self)
  end

  def update_tax_charge
    # TaxRate.adjust(order, [self])
  end

  def ensure_proper_currency
    unless currency == order.currency
      errors.add(:currency, :must_match_order_currency)
    end
  end
end