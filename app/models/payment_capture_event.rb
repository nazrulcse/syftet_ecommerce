class PaymentCaptureEvent < Base
  belongs_to :payment, class_name: 'Payment'

  def display_amount
    Money.new(amount, payment.currency)
  end
end