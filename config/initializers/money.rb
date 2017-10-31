class Money
  def to_display
    Money.new(self.fractional * 100, self.currency).format
  end
end