Feature: Testing an empty widget

Scenario: An unsaved widget should respond to litecoin_payments
Given an unsaved widget
Then the widget should have 0 litecoin_payments