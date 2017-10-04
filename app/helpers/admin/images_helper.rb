module Admin
  module ImagesHelper
    def options_text_for(image)
      if image.viewable.is_a?(Variant)
        if image.viewable.is_master?
          t(:all)
        else
          image.viewable.sku_and_options_text
        end
      else
        t(:all)
      end
    end
  end
end
