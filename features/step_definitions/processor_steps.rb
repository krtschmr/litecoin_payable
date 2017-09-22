When /^the payment_processor is run$/ do
  LitecoinPayable::PaymentProcessor.perform
end

When /^the pricing processor is run$/ do
  LitecoinPayable::PricingProcessor.perform
end