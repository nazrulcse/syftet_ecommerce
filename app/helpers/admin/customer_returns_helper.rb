module Admin
  module CustomerReturnsHelper
    def reimbursement_types
      @reimbursement_types ||= ReimbursementType.accessible_by(current_ability, :read).active
    end
  end
end