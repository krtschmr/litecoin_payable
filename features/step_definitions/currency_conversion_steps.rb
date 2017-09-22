Given /^there should be (\d+) currency_conversions?$/ do |n|
  expect(@currency_conversions).to_not be_nil
  expect(@currency_conversions.count).to eq(n.to_i)
end

Given /^the currency_conversion is (\d+)$/ do |conversion_rate|
  LitecoinPayable::CurrencyConversion.create!(
    currency: 1,
    ltc: conversion_rate.to_i,
  )
  @currency_conversions = LitecoinPayable::CurrencyConversion.all
end