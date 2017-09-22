Given /^the widget should have (\d+) litecoin_payments$/ do |n|
  expect(@widget.litecoin_payments.count).to eq(n.to_i)
end