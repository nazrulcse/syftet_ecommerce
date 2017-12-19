class Money
  #self.default_bank.add_rate('GBP', 'USD', 0.012)

  def to_display
    Money.new(self.fractional, 'GBP').format
  end
end