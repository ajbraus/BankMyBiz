module SubscriptionsHelper
  def price_in_dollars(price_in_cents)
    val = price_in_cents.to_d/100
    return sprintf "$%.2f", val
  end
end