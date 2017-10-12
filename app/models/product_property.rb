class ProductProperty < Base
  acts_as_list scope: :product

  with_options inverse_of: :product_properties do
    belongs_to :product, touch: true, class_name: 'Product'
    belongs_to :property, class_name: 'Property'
  end

  validates :property, presence: true

  # validates :value, db_maximum_length: true
  validates :value, presence: true

  default_scope { order(:position) }

  self.whitelisted_ransackable_attributes = ['value']

  # virtual attributes for use with AJAX completion stuff
  delegate :name, to: :property, prefix: true, allow_nil: true

  def property_name=(name)
    if name.present?
      # don't use `find_by :name` to workaround globalize/globalize#423 bug
      self.property = Property.where(name: name).first_or_create(presentation: name)
    end
  end
end