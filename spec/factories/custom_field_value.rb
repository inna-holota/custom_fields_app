# spec/factories/custom_field_value.rb
FactoryBot.define do
  factory :custom_field_value do
    association :user           # The user associated with the value
    association :custom_field   # The custom field that this value corresponds to

    # Default to a text/custom value (valid for text/number fields)
    value { 'Test Value' } 

    trait :with_custom_field_option do
      association :custom_field_option
      value { nil } # Ensure "value" is not set for options-based fields
    end

    trait :text_value do
      association :custom_field, factory: [:custom_field, :text_type]
      value { 'Sample Text' }
    end

    trait :number_value do
      association :custom_field, factory: [:custom_field, :number_type]
      value { '12345' }
    end

    trait :single_select_value do
      association :custom_field, factory: [:custom_field, :single_select_type]
      association :custom_field_option, factory: :custom_field_option
      value { nil } # Always set this to nil for select-fields
    end

    trait :multi_select_value do
      association :custom_field, factory: [:custom_field, :multi_select_type]
      custom_field_option { nil } # Use other logic for multi-select handling
      value { nil }
    end
  end
end