Given /^an unsaved widget$/ do
  @widget = Widget.new
end

Given /^a saved widget$/ do
  @widget = Widget.create
end

Given /^a new litecoin_payment$/ do
  @litecoin_payment = @widget.litecoin_payments.new
end
