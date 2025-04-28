class CustomField < ApplicationRecord
  TEXT_TYPE = 'text'
  NUMBER_TYPE = 'number'
  SINGLE_SELECT_TYPE = 'single_select'
  MULTI_SELECT_TYPE = 'multi_select'
  enum :field_type, [TEXT_TYPE, NUMBER_TYPE, SINGLE_SELECT_TYPE, MULTI_SELECT_TYPE].map(&:to_sym)

  has_many :custom_field_options
  has_many :custom_field_values
  belongs_to :tenant
end