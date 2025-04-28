FactoryBot.define do
  factory :user do
    tenant
    first_name { 'John' }
    last_name { 'Doe' }
    email { 'john.doe@test.com' }
  end
end