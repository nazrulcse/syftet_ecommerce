module Admin
  class VariantsIncludingMasterController < VariantsController
    belongs_to "product", find_by: :slug

    def model_class
      Variant
    end

    def object_name
      "variant"
    end

  end
end