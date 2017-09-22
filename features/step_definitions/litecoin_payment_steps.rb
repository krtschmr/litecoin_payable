Given /^the litecoin_payment field (\S*) is set to (.*)/ do |field, value|
  @litecoin_payment.send("#{field}=", value)
end

Given /^the litecoin_payment is saved$/ do
  @litecoin_payment.save
  expect(@litecoin_payment.reload.new_record?).to be(false)
end

Given /^the litecoin_payment should have an address$/ do
  expect(@litecoin_payment.address).to_not be(nil)
end

Given /^the litecoin_payment should have the state (\S+)$/ do |state|
  expect(@litecoin_payment.reload.state).to eq(state)
end

Given /^the ltc_amount_due is set$/ do
  @ltc_amount_due = @litecoin_payment.calculate_ltc_amount_due
end

Given /^a payment is made for (\d+) percent$/ do |percentage|
  @litecoin_payment.transactions.create!(estimated_value: LitecoinPayable::LitecoinCalculator.convert_litecoins_to_satoshis(@ltc_amount_due * (percentage.to_f / 100.0)), ltc_conversion: @litecoin_payment.ltc_conversion)
end

Given(/^the amount paid percentage should be greater than (\d+)%$/) do |percentage|
  expect(@litecoin_payment.currency_amount_paid / @litecoin_payment.price.to_f).to be >= (percentage.to_f / 100)
end

Given(/^the amount paid percentage should be less than (\d+)%$/) do |percentage|
  expect(@litecoin_payment.currency_amount_paid / @litecoin_payment.price).to be < (percentage.to_f / 100)
end

Given(/^the amount paid percentage should be (\d+)%$/) do |percentage|
  expect(@litecoin_payment.currency_amount_paid / @litecoin_payment.price.to_f).to  eq(percentage.to_f / 100)
end