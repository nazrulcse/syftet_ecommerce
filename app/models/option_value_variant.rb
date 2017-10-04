class OptionValueVariant < Base
  belongs_to :option_value, class_name: 'OptionValue'
  belongs_to :variant, class_name: 'Variant'
end