class Classification < Base
  self.table_name = 'products_taxons'
  acts_as_list scope: :taxon

  with_options inverse_of: :classifications, touch: true do
    belongs_to :product, class_name: "Product"
    belongs_to :taxon, class_name: "Taxon"
  end

  validates :taxon, :product, presence: true
  # For #3494
  validates :taxon_id, uniqueness: {scope: :product_id, message: :already_linked, allow_blank: true}
end