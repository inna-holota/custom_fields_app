class CustomFieldOption < ApplicationRecord
  belongs_to :custom_field

  validates :value, presence: true
  validates :value, uniqueness: { scope: :custom_field_id, message: 'Option values must be unique for a custom field' }
end
