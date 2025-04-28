# spec/factories/custom_field_option.rb
FactoryBot.define do
  factory :custom_field_option do
    association :custom_field
    value { 'Test Option' }
  end
end