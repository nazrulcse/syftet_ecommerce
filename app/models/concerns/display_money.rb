module DisplayMoney
  ##
  # Takes a list of methods that the base object wants to be able to use
  # to display with Money, and turns them into display_* methods.
  # Intended to help clean up some of the presentational logic that exists
  # at the model layer.
  #
  #
  # ==== Examples
  # Decorate a method, with the default option of using the base object's
  # currency
  #
  #     extend DisplayMoney
  #     money_methods :tax_amount, :price
  #
  # Decorate a method, but with some additional options
  #     extend DisplayMoney
  #     money_methods tax_amount: { currency: "CAD", no_cents: true }, :price
  def money_methods(*args)
    args.each do |money_method|
      money_method = {money_method => {}} unless money_method.is_a? Hash
      money_method.each do |method_name, opts|
        define_method("display_#{method_name}") do
          opt_currency = respond_to?(:currency) ? currency : Syftet.config.currency
          Money.new(send(method_name), opt_currency)
        end
      end
    end
  end
end