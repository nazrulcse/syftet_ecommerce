# TODO let friendly id take care of sanitizing the url
require 'stringex'

class Taxon < Base
  extend FriendlyId
  friendly_id :permalink, slug_column: :permalink, use: :slugged
  before_create :set_permalink

  belongs_to :taxonomy, class_name: 'Taxonomy', inverse_of: :taxons
  has_many :classifications, -> { order(:position) }, dependent: :delete_all, inverse_of: :taxon
  has_many :products, through: :classifications

  validates :name, presence: true

  with_options length: {maximum: 255}, allow_blank: true do
    validates :meta_keywords
    validates :meta_description
    validates :meta_title
  end

  # has_attached_file :icon,
  #                   styles: {mini: '32x32>', normal: '128x128>'},
  #                   default_style: :mini,
  #                   url: '/spree/taxons/:id/:style/:basename.:extension',
  #                   path: ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
  #                   default_url: '/assets/default_taxon.png'
  #
  # validates_attachment :icon,
  #                      content_type: {content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]}

  # Return meta_title if set otherwise generates from root name and/or taxon name
  def seo_title
    unless meta_title.blank?
      meta_title
    else
      root? ? name : "#{root.name} - #{name}"
    end
  end

  # Creates permalink base for friendly_id
  def set_permalink
    if parent.present?
      self.permalink = [parent.permalink, (permalink.blank? ? name.to_url : permalink.split('/').last)].join('/')
    else
      self.permalink = name.to_url if permalink.blank?
    end
  end

  def active_products
    products.active
  end

  def pretty_name
    ancestor_chain = self.ancestors.inject("") do |name, ancestor|
      name += "#{ancestor.name} -> "
    end
    ancestor_chain + "#{name}"
  end
end