class CustomField < ApplicationRecord
  enum :field_type, [:text, :number, :single_select, :multi_select]

  has_many :custom_field_options
  has_many :custom_field_values
  belongs_to :tenant

  def valid_value?(value)
    case field_type
    when 'text' then value.is_a?(String)
    when 'number' then value.is_a?(Numeric)
    when 'single_select' then options.include?(value.to_s)
    when 'multi_select' then Array(value).all? { |v| options.include?(v.to_s) }
    else false
    end
  end
end