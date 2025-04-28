FactoryBot.define do
  factory :custom_field do
    association :tenant
    name { 'Default Custom Field' }
    field_type { 'text' }
  end
end
