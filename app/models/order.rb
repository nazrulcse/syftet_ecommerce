require 'order/checkout'
class Order < Base
  PAYMENT_STATES = %w(balance_due credit_owed failed paid void)
  SHIPMENT_STATES = %w(backorder canceled partial processing pending ready shipped delivered canceled refunded )
  ORDER_SHIPMENT_STATE = {
      processing: 'Processing',
      payment_failed: 'Payment failed',
      pending: 'Preparing your order',
      ready: 'Ready to ship',
      shipped: 'Shipped'
  }

  ORDER_ALL_SHIPMENT_STATE = {
      processing: 'Processing',
      payment_failed: 'Payment failed',
      pending: 'Preparing your order',
      ready: 'Ready to ship',
      shipped: 'Shipped',
      delivered: 'Delivered',
      canceled: 'Canceled',
      refunded: 'Refunded'
  }

  ORDER_SMTP = {
      address: 'smtp.zoho.com',
      port: 465,
      domain: 'lienesbeauty.com',
      user_name: 'sales@lienesbeauty.com',
      password: 'Shop2017',
      authentication: :plain,
      ssl: true,
      enable_starttls_auto: true
  }

  extend FriendlyId
  friendly_id :number, slug_column: :number, use: :slugged

  include Order::Checkout
  include Order::CurrencyUpdater
  include Order::Payments
  include Order::StoreCredit
  include Core::NumberGenerator.new(prefix: "BR-#{rand.to_s[2..5]}-")
  include Core::TokenGenerator

  extend DisplayMoney
  money_methods :outstanding_balance, :item_total, :adjustment_total,
                :included_tax_total, :additional_tax_total, :tax_total,
                :shipment_total, :promo_total, :total

  alias :display_ship_total :display_shipment_total
  alias_attribute :ship_total, :shipment_total

  MONEY_THRESHOLD = 100_000_000
  MONEY_VALIDATION = {
      presence: true,
      numericality: {
          greater_than: -MONEY_THRESHOLD,
          less_than: MONEY_THRESHOLD,
          allow_blank: true
      },
      format: {with: /\A-?\d+(?:\.\d{1,2})?\z/, allow_blank: true}
  }.freeze

  POSITIVE_MONEY_VALIDATION = MONEY_VALIDATION.deep_dup.tap do |validation|
    validation.fetch(:numericality)[:greater_than_or_equal_to] = 0
  end.freeze

  NEGATIVE_MONEY_VALIDATION = MONEY_VALIDATION.deep_dup.tap do |validation|
    validation.fetch(:numericality)[:less_than_or_equal_to] = 0
  end.freeze

  checkout_flow do
    go_to_state :address
    go_to_state :delivery
    go_to_state :payment, if: ->(order) { order.payment_required? }
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :complete
    remove_transition from: :delivery, to: :confirm
  end

  self.whitelisted_ransackable_associations = %w[shipments user promotions bill_address ship_address line_items]
  self.whitelisted_ransackable_attributes = %w[completed_at created_at email number state payment_state shipment_state total considered_risky]

  attr_reader :coupon_code
  attr_accessor :temporary_address, :temporary_credit_card

  # if user_class
  #   belongs_to :user, class_name: Spree.user_class.to_s
  #   belongs_to :created_by, class_name: Spree.user_class.to_s # TODO: Default user class is user
  #   belongs_to :approver, class_name: Spree.user_class.to_s
  #   belongs_to :canceler, class_name: Spree.user_class.to_s
  # else
  belongs_to :user
  belongs_to :created_by, class_name: 'User'
  belongs_to :approver, class_name: 'User'
  belongs_to :canceler, class_name: 'User'
  has_one :rewards_point
  # end

  belongs_to :bill_address, foreign_key: :bill_address_id, class_name: 'Address'
  alias_attribute :billing_address, :bill_address

  belongs_to :ship_address, foreign_key: :ship_address_id, class_name: 'Address'
  alias_attribute :shipping_address, :ship_address

  belongs_to :store, class_name: 'Store'

  with_options dependent: :destroy do
    has_many :state_changes, as: :stateful
    has_many :line_items, -> { order(:created_at) }, inverse_of: :order
    has_many :payments
    has_many :return_authorizations, inverse_of: :order
    has_many :adjustments, -> { order(:created_at) }, as: :adjustable
  end
  has_many :reimbursements, inverse_of: :order
  has_many :line_item_adjustments, through: :line_items, source: :adjustments
  has_many :shipment_adjustments, through: :shipments, source: :adjustments
  has_many :inventory_units, inverse_of: :order
  has_many :products, through: :variants
  has_many :variants, through: :line_items
  has_many :refunds, through: :payments
  has_many :all_adjustments,
           class_name: 'Adjustment',
           foreign_key: :order_id,
           dependent: :destroy,
           inverse_of: :order

  has_many :order_promotions, class_name: 'OrderPromotion'
  has_many :promotions, through: :order_promotions, class_name: 'Promotion'
  has_many :order_tracks, class_name: "OrderTrack", foreign_key: :order_id

  has_many :shipments, dependent: :destroy, inverse_of: :order do
    def states
      pluck(:state).uniq
    end
  end

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :bill_address
  accepts_nested_attributes_for :ship_address
  accepts_nested_attributes_for :payments
  accepts_nested_attributes_for :shipments

  # Needs to happen before save_permalink is called
  before_validation :set_currency
  before_validation :clone_shipping_address, if: :use_shipping?
  attr_accessor :use_shipping

  before_create :create_token
  before_create :link_by_email
  before_update :homogenize_line_item_currencies, if: :currency_changed?
  after_save :collect_rewards_point

  with_options presence: true do
    validates :number, length: {maximum: 32, allow_blank: true}, uniqueness: {allow_blank: true}
    validates :email, length: {maximum: 254, allow_blank: true}, if: :require_email
    validates :item_count, numericality: {greater_than_or_equal_to: 0, less_than: 2**31, only_integer: true}, allow_blank: true
  end
  validates :payment_state, inclusion: {in: PAYMENT_STATES, allow_blank: true}
  validates :shipment_state, inclusion: {in: SHIPMENT_STATES, allow_blank: true}
  validates :item_total, POSITIVE_MONEY_VALIDATION
  validates :adjustment_total, MONEY_VALIDATION
  # validates :included_tax_total, POSITIVE_MONEY_VALIDATION
  # validates :additional_tax_total, POSITIVE_MONEY_VALIDATION
  validates :payment_total, MONEY_VALIDATION
  validates :shipment_total, MONEY_VALIDATION
  validates :promo_total, NEGATIVE_MONEY_VALIDATION
  validates :total, MONEY_VALIDATION

  delegate :update_totals, :persist_totals, to: :updater
  delegate :merge!, to: :merger
  delegate :firstname, :lastname, to: :bill_address, prefix: true, allow_nil: true

  class_attribute :update_hooks
  self.update_hooks = Set.new

  class_attribute :line_item_comparison_hooks
  self.line_item_comparison_hooks = Set.new

  scope :created_between, ->(start_date, end_date) { where(created_at: start_date..end_date) }
  scope :completed_between, ->(start_date, end_date) { where(completed_at: start_date..end_date) }
  scope :complete, -> { where.not(completed_at: nil) }
  # scope :incomplete, -> { where(completed_at: nil) }

  def self.incomplete
    where(completed_at: nil)
  end

  # shows completed orders first, by their completed_at date, then uncompleted orders by their created_at
  scope :reverse_chronological, -> { order('orders.completed_at IS NULL', completed_at: :desc, created_at: :desc) }

  # Use this method in other gems that wish to register their own custom logic
  # that should be called after Order#update
  def self.register_update_hook(hook)
    self.update_hooks.add(hook)
  end

  def payment_failed?
    payment_state == 'failed'
  end

  # Use this method in other gems that wish to register their own custom logic
  # that should be called when determining if two line items are equal.
  def self.register_line_item_comparison_hook(hook)
    self.line_item_comparison_hooks.add(hook)
  end

  # For compatiblity with Calculator::PriceSack
  def amount
    line_items.inject(0.0) { |sum, li| sum + li.amount }
  end

  # Sum of all line item amounts pre-tax
  def pre_tax_item_amount
    line_items.to_a.sum(&:pre_tax_amount)
  end

  def currency
    self[:currency] || Syftet.config.currency
  end

  def shipping_discount
    shipment_adjustments.eligible.sum(:amount) * -1
  end

  def completed?
    completed_at.present?
  end

  # Indicates whether or not the user is allowed to proceed to checkout.
  # Currently this is implemented as a check for whether or not there is at
  # least one LineItem in the Order.  Feel free to override this logic in your
  # own application if you require additional steps before allowing a checkout.
  def checkout_allowed?
    line_items.count > 0
  end

  # Is this a free order in which case the payment step should be skipped
  def payment_required?
    total.to_f > 0.0
  end

  # If true, causes the confirmation step to happen during the checkout process
  def confirmation_required?
    # Config[:always_include_confirm_step] ||
    #     payments.valid.map(&:payment_method).compact.any?(&:payment_profiles_supported?) ||
    #     # Little hacky fix for #4117
    #     # If this wasn't here, order would transition to address state on confirm failure
    #     # because there would be no valid payments any more.
    #     confirm?
    false
  end

  def backordered?
    shipments.any?(&:backordered?)
  end

  # Returns the relevant zone (if any) to be used for taxation purposes.
  # Uses default tax zone unless there is a specific match
  def tax_zone
    # @tax_zone ||= Zone.match(tax_address) || Zone.default_tax
  end

  # Returns the address for taxation based on configuration
  def tax_address
    Config[:tax_using_ship_address] ? ship_address : bill_address
  end

  def updater
    @updater ||= OrderUpdater.new(self)
  end

  def update_with_updater!
    updater.update
  end

  def update!
    warn "`update!` is deprecated as it conflicts with update! method of rails. Use `update_with_updater!` instead."
    update_with_updater!
  end

  def merger
    @merger ||= OrderMerger.new(self)
  end

  def clone_shipping_address
    if ship_address and self.bill_address.nil?
      self.bill_address = ship_address.clone
    else
      self.bill_address.attributes = ship_address.attributes.except('id', 'updated_at', 'created_at')
    end
    true
  end

  def clone_billing_address
    if bill_address and self.ship_address.nil?
      self.ship_address = bill_address.clone
    else
      self.ship_address.attributes = bill_address.attributes.except('id', 'updated_at', 'created_at')
    end
    true
  end

  def allow_cancel?
    return false if !completed? || canceled?
    shipment_state.nil? || %w{ready backorder pending}.include?(shipment_state)
  end

  def all_inventory_units_returned?
    inventory_units.all? { |inventory_unit| inventory_unit.returned? }
  end

  def contents
    @contents ||= OrderContents.new(self)
  end

  # Associates the specified user with the order.
  def associate_user!(user, override_email = true)
    self.user = user
    self.email = user.email if override_email
    self.created_by ||= user
    self.bill_address ||= user.bill_address
    self.ship_address ||= user.ship_address

    changes = slice(:user_id, :email, :created_by_id, :bill_address_id, :ship_address_id)

    # immediately persist the changes we just made, but don't use save
    # since we might have an invalid address associated
    self.class.unscoped.where(id: self).update_all(changes)
  end

  def quantity_of(variant, options = {})
    line_item = find_line_item_by_variant(variant, options)
    line_item ? line_item.quantity : 0
  end

  def find_line_item_by_variant(variant, options = {})
    line_items.detect { |line_item|
      line_item.variant_id == variant.id &&
          line_item_options_match(line_item, options)
    }
  end

  def get_shipment_status
    if ['delivered', 'canceled', 'refunded'].include? self.shipment_state
      Order::ORDER_ALL_SHIPMENT_STATE
    else
      Order::ORDER_SHIPMENT_STATE
    end
  end

  # This method enables extensions to participate in the
  # "Are these line items equal" decision.
  #
  # When adding to cart, an extension would send something like:
  # params[:product_customizations]={...}
  #
  # and would provide:
  #
  # def product_customizations_match
  def line_item_options_match(line_item, options)
    return true unless options

    self.line_item_comparison_hooks.all? { |hook|
      self.send(hook, line_item, options)
    }
  end

  # Creates new tax charges if there are any applicable rates. If prices already
  # include taxes then price adjustments are created instead.
  def create_tax_charge!
    TaxRate.adjust(self, line_items)
    TaxRate.adjust(self, shipments) if shipments.any?
  end

  def update_line_item_prices!
    transaction do
      line_items.each(&:update_price)
      save!
    end
  end

  def outstanding_balance
    # if canceled?
    #   -1 * payment_total
    # elsif reimbursements.includes(:refunds).size > 0
    #   reimbursed = reimbursements.includes(:refunds).inject(0) do |sum, reimbursement|
    #     sum + reimbursement.refunds.sum(:amount)
    #   end
    #   # If reimbursement has happened add it back to total to prevent balance_due payment state
    #   # See: https://github.com/spree/spree/issues/6229
    #   total - (payment_total + reimbursed)
    # else
    #   total - payment_total
    # end
    0 # TODO: Check if this realy required
  end

  def outstanding_balance?
    self.outstanding_balance != 0
  end

  def name
    if (address = bill_address || ship_address)
      address.full_name
    end
  end

  def can_ship?
    self.complete? || self.resumed? || self.awaiting_return? || self.returned?
  end

  def credit_cards
    credit_card_ids = payments.from_credit_card.pluck(:source_id).uniq
    CreditCard.where(id: credit_card_ids)
  end

  def valid_credit_cards
    credit_card_ids = payments.from_credit_card.valid.pluck(:source_id).uniq
    CreditCard.where(id: credit_card_ids)
  end

  # Finalizes an in progress order after checkout is complete.
  # Called after transition to complete state when payments will have been processed
  def finalize!
    # lock all adjustments (coupon promotions, etc.)
    all_adjustments.each { |a| a.close }

    # update payment and shipment(s) states, and save
    updater.update_payment_state
    shipments.each do |shipment|
      shipment.update!(self)
      shipment.finalize!
    end

    updater.update_shipment_state
    save!
    updater.run_hooks

    touch :completed_at

    deliver_order_confirmation_email unless confirmation_delivered?

    update_column(:shipment_state, nil)

    consider_risk
  end

  def fulfill!
    shipments.each { |shipment| shipment.update!(self) if shipment.persisted? }
    updater.update_shipment_state
    save!
  end

  def deliver_order_confirmation_email
    OrderMailer.confirm_email(id).deliver_now # TODO: will send email after getting smtp credential
    update_column(:confirmation_delivered, true)
    update_column(:shipment_state, nil)
  end

  # Helper methods for checkout steps
  def paid?
    payment_state == 'paid' || payment_state == 'credit_owed'
  end

  def available_payment_methods
    @available_payment_methods ||= PaymentMethod.available_on_front_end
  end

  def insufficient_stock_lines
    line_items.select(&:insufficient_stock?)
  end

  ##
  # Check to see if any line item variants are discontinued.
  # If so add error and restart checkout.
  def ensure_line_item_variants_are_not_discontinued
    if line_items.any? { |li| !li.variant || li.variant.discontinued? }
      restart_checkout_flow
      errors.add(:base, Spree.t(:discontinued_variants_present))
      false
    else
      true
    end
  end

  def ensure_line_items_are_in_stock
    if insufficient_stock_lines.present?
      restart_checkout_flow
      errors.add(:base, Spree.t(:insufficient_stock_lines_present))
      false
    else
      true
    end
  end

  def empty!
    if completed?
      raise t(:cannot_empty_completed_order)
    else
      line_items.destroy_all
      updater.update_item_count
      adjustments.destroy_all
      shipments.destroy_all
      state_changes.destroy_all
      order_promotions.destroy_all

      update_totals
      persist_totals
      restart_checkout_flow
      self
    end
  end

  def has_step?(step)
    checkout_steps.include?(step)
  end

  def state_changed(name)
    state = "#{name}_state"
    if persisted?
      old_state = self.send("#{state}_was")
      new_state = self.send(state)
      unless old_state == new_state
        self.state_changes.create(
            previous_state: old_state,
            next_state: new_state,
            name: name,
            user_id: self.user_id
        )
      end
    end
  end

  def coupon_code=(code)
    @coupon_code = code.strip.downcase rescue nil
  end

  def can_add_coupon?
    Promotion.order_activatable?(self)
  end


  def shipped?
    %w(partial shipped).include?(shipment_state)
  end

  def create_proposed_shipments
    all_adjustments.shipping.delete_all
    shipments.destroy_all
    p self.shipments.inspect
    self.shipments = Stock::Coordinator.new(self).shipments
  end

  def apply_free_shipping_promotions
    PromotionHandler::FreeShipping.new(self).activate
    shipments.each { |shipment| Adjustable::AdjustmentsUpdater.update(shipment) }
    updater.update_shipment_total
    persist_totals
  end

  # Clean shipments and make order back to address state
  #
  # At some point the might need to force the order to transition from address
  # to delivery again so that proper updated shipments are created.
  # e.g. customer goes back from payment step and changes order items
  def ensure_updated_shipments
    if shipments.any? && !self.completed?
      self.shipments.destroy_all
      self.update_column(:shipment_total, 0)
      restart_checkout_flow
    end
  end

  def restart_checkout_flow
    self.update_columns(
        state: 'cart',
        updated_at: Time.current,
    )
    self.next! if self.line_items.size > 0
  end

  def refresh_shipment_rates(shipping_method_filter = ShippingMethod::DISPLAY_ON_FRONT_END)
    shipments.map { |s| s.refresh_rates(shipping_method_filter) }
  end

  def shipping_eq_billing_address?
    (bill_address.empty? && ship_address.empty?) || bill_address.same_as?(ship_address)
  end

  def set_shipments_cost
    shipments.each(&:update_amounts)
    updater.update_shipment_total
    persist_totals
  end

  def is_risky?
    payments.risky.size > 0
  end

  def canceled_by(user)
    self.transaction do
      cancel!
      self.update_columns(
          canceler_id: user.id,
          canceled_at: Time.current,
      )
    end
  end

  def approved_by(user)
    self.transaction do
      approve!
      self.update_columns(
          approver_id: user.id,
          approved_at: Time.current,
      )
    end
  end

  def approved?
    !!self.approved_at
  end

  def credit_rewards_point
    points = line_items.collect { |item| item.variant.credit_point }.sum
    RewardsPoint.create(order_id: self.id, user_id: self.user_id, points: points, reason: 'Order Checkout Credit Points')
  end

  def can_approve?
    !approved?
  end

  def consider_risk
    if is_risky? && !approved?
      considered_risky!
    end
  end

  def considered_risky!
    update_column(:considered_risky, true)
  end

  def approve!
    update_column(:considered_risky, false)
  end

  def reload(options=nil)
    # remove_instance_variable(:@tax_zone) if defined?(@tax_zone) TODO: Not consider taxt this time
    super
  end

  def tax_total
    included_tax_total + additional_tax_total
  end

  def quantity
    line_items.sum(:quantity)
  end

  def has_non_reimbursement_related_refunds?
    refunds.non_reimbursement.exists? ||
        payments.offset_payment.exists? # how old versions of spree stored refunds
  end

  # determines whether the inventory is fully discounted
  #
  # Returns
  # - true if inventory amount is the exact negative of inventory related adjustments
  # - false otherwise
  def fully_discounted?
    adjustment_total + line_items.map(&:final_amount).sum == 0.0
  end

  alias_method :fully_discounted, :fully_discounted?

  private

  def create_store_credit_payment(payment_method, credit, amount)
    payments.create!(
        source: credit,
        payment_method: payment_method,
        amount: amount,
        state: 'checkout',
        response_code: credit.generate_authorization_code
    )
  end

  def store_credit_amount(credit, total)
    [credit.amount_remaining, total].min
  end

  def link_by_email
    self.email = user.email if self.user
  end

  # Determine if email is required (we don't want validation errors before we hit the checkout)
  def require_email
    true unless new_record? or ['cart', 'address'].include?(state)
  end

  def ensure_line_items_present
    unless line_items.present?
      errors.add(:base, Spree.t(:there_are_no_items_for_this_order)) and return false
    end
  end

  def ensure_available_shipping_rates
    # if shipments.empty? || shipments.any? { |shipment| shipment.shipping_rates.blank? }
    #   # After this point, order redirects back to 'address' state and asks user to pick a proper address
    #   # Therefore, shipments are not necessary at this point.
    #   shipments.destroy_all
    #   errors.add(:base, Spree.t(:items_cannot_be_shipped)) and return false
    # end
  end

  def after_cancel
    shipments.each { |shipment| shipment.cancel! }
    payments.completed.each { |payment| payment.cancel! }

    # Free up authorized store credits
    # payments.store_credits.pending.each(&:void!)

    send_cancel_email
    self.update_with_updater!
  end

  def send_cancel_email
    OrderMailer.cancel_email(id).deliver_later
  end

  def after_resume
    shipments.each { |shipment| shipment.resume! }
    consider_risk
  end

  def use_shipping?
    use_shipping.in?([true, 'true', '1', 1])
  end

  def use_billing?
    use_billing.in?([true, 'true', '1', 1])
  end

  def set_currency
    self.currency = Syftet.config.currency
  end

  def create_token
    self.guest_token ||= generate_guest_token
  end

  def collect_rewards_point
    if self.user.present? && self.approved_at.present?
      reward_point = self.user.rewards_points.find_or_initialize_by(order_id: self.id, user_id: self.user_id, reason: 'Checkout')
      reward_point.points = self.line_items.sum(&:credit_point)
      reward_point.save
    end
  end
end