class RoleUser < Base
  belongs_to :role, class_name: 'Role'
  belongs_to :user, class_name: 'User'
end