module DefaultPrice
  extend ActiveSupport::Concern
  include DelegateBelongsTo

  included do
    has_one :default_price,
            #-> { where currency: Spree::Config[:currency] }, TODO: need to activate config
            -> { where currency: 'usd' },
            class_name: 'Price',
            dependent: :destroy

    delegate_belongs_to :default_price,
                        :display_price,
                        :display_amount,
                        :price,
                        :price=,
                        :price_including_vat_for,
                        :currency

    after_save :save_default_price

    def default_price
      Price.unscoped { super }
    end

    def has_default_price?
      !self.default_price.nil?
    end

    private

    def default_price_changed?
      default_price && (default_price.changed? || default_price.new_record?)
    end

    def save_default_price
      default_price.save if default_price_changed?
    end
  end
end