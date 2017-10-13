class ShippingMethod < Base
  acts_as_paranoid
  include CalculatedAdjustments
  DISPLAY = [:both, :front_end, :back_end]

  # Used for #refresh_rates
  DISPLAY_ON_FRONT_AND_BACK_END = 0
  DISPLAY_ON_FRONT_END = 1
  DISPLAY_ON_BACK_END = 2

  default_scope { where(deleted_at: nil) }

  has_many :shipping_method_categories, dependent: :destroy
  has_many :shipping_categories, through: :shipping_method_categories
  has_many :shipping_rates, inverse_of: :shipping_method
  has_many :shipments, through: :shipping_rates

  has_many :shipping_method_zones, class_name: 'ShippingMethodZone',
           foreign_key: 'shipping_method_id'
  has_many :zones, through: :shipping_method_zones, class_name: 'Zone'

  # belongs_to :tax_category, class_name: 'TaxCategory'

  validates :name, presence: true

  validate :at_least_one_shipping_category

  def include?(address)
    return false unless address
    # zones.includes(:zone_members).any? do |zone|
    #   zone.include?(address)
    # end
    # TODO: We are not considering zone this time, So return true all time
    true
  end

  def build_tracking_url(tracking)
    return if tracking.blank? || tracking_url.blank?
    tracking_url.gsub(/:tracking/, ERB::Util.url_encode(tracking)) # :url_encode exists in 1.8.7 through 2.1.0
  end

  def self.calculators
    # spree_calculators.send(model_name_without_spree_namespace) TODO: Note had to overwrite code
    #     .select { |c| c.to_s.constantize < ShippingCalculator }
    spree_calculators[model_name_without_spree_namespace.to_sym]
        .select { |c| c.to_s.constantize < ShippingCalculator }
  end

  # Some shipping methods are only meant to be set via backend
  def frontend?
    self.display_on != "back_end"
  end

  def tax_category
    TaxCategory.unscoped { super }
  end

  def available_to_display(display_filter)
    display_filter == DISPLAY_ON_FRONT_AND_BACK_END ||
        (frontend? && display_filter == DISPLAY_ON_FRONT_END) ||
        (!frontend? && display_filter == DISPLAY_ON_BACK_END)
  end

  private

  def at_least_one_shipping_category
    if shipping_categories.empty?
      errors.add(:base, :required_shipping_category)
    end
  end
end