class Role < Base
  has_many :role_users, class_name: 'RoleUser', dependent: :destroy
  has_many :users, through: :role_users, class_name: 'User' #Spree.user_class.to_s

  validates :name, presence: true, uniqueness: {allow_blank: true}
end