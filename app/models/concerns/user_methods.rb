module UserMethods
  extend ActiveSupport::Concern

  include UserApiAuthentication
  include UserPaymentSource
  include UserReporting
  include RansackableAttributes

  included do
    has_many :role_users, class_name: 'RoleUser', foreign_key: :user_id, dependent: :destroy
    has_many :roles, through: :role_users, class_name: 'Role', source: :role

    has_many :promotion_rule_users, class_name: 'PromotionRuleUser', foreign_key: :user_id, dependent: :destroy
    has_many :promotion_rules, through: :promotion_rule_users, class_name: 'PromotionRule'

    has_many :orders, foreign_key: :user_id, class_name: "Order"
    has_many :store_credits, foreign_key: :user_id, class_name: 'StoreCredit'

    belongs_to :ship_address, class_name: 'Address'
    belongs_to :bill_address, class_name: 'Address'

    self.whitelisted_ransackable_associations = %w[bill_address ship_address]
    self.whitelisted_ransackable_attributes = %w[id email]
  end

  # has_spree_role? simply needs to return true or false whether a user has a role or not.
  def has_spree_role?(role_in_question)
    spree_roles.any? { |role| role.name == role_in_question.to_s }
  end

  def last_incomplete_spree_order
    orders.incomplete.
        includes(line_items: [variant: [:images, :option_values, :product]]).
        order('created_at DESC').
        first
  end

  def analytics_id
    id
  end

  def total_available_store_credit
    store_credits.reload.to_a.sum(&:amount_remaining)
  end
end