class User < ApplicationRecord
  include UserMethods
  include UserAddress
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :ship_address, class_name: 'Address', optional: true
  belongs_to :bill_address, class_name: 'Address', optional: true

  users_table_name = User.table_name
  roles_table_name = Role.table_name

  scope :admin, -> { includes(:roles).where("#{roles_table_name}.name" => "admin") }

  def self.admin_created?
    User.admin.count > 0
  end

  def admin?
    has_spree_role?('admin')
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  def generate_syftet_api_key!

  end
end
