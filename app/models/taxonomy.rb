class Taxonomy < Base
  acts_as_list

  validates :name, presence: true

  has_many :taxons, inverse_of: :taxonomy

  default_scope { order("#{self.table_name}.position, #{self.table_name}.created_at") }
end