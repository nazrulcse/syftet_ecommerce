class ReturnAuthorizationReason < Base
  include NamedType

  has_many :return_authorizations, dependent: :restrict_with_error
end
