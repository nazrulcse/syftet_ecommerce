class PaymentMethod::CreditPoint < PaymentMethod
  def actions
    %w{capture void}
  end

  # Indicates whether its possible to capture the payment
  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end

  # Indicates whether its possible to void the payment.
  def can_void?(payment)
    payment.state != 'void'
  end

  def capture(*)
    response = simulated_successful_billing_response
    if response.success?
      update_rewards_points(-1 * amount.to_f, 'Purchased', options)
    end
  end

  def purchase(amount, source, options = {})
    response = simulated_successful_billing_response
    if response.success?
      update_rewards_points(-1 * amount.to_f, 'Purchased', options)
    end
    response
  end

  def cancel(amount, source, order, code)
    response = simulated_successful_billing_response
    if response.success?
      update_rewards_points(amount.to_f, 'Purchased Canceled', order)
    end
    response
  end

  def void(*)
    simulated_successful_billing_response
  end

  def source_required?
    false
  end

  def credit(*)
    simulated_successful_billing_response
  end

  private

  def simulated_successful_billing_response
    ActiveMerchant::Billing::Response.new(true, '', {}, {authorization: true})
  end

  def update_rewards_points(amount, reason, order)
    RewardsPoint.create(order_id: order.id, points: amount, reason: reason, user_id: order.user_id)
  end

end