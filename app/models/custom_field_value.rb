class CustomFieldValue < ApplicationRecord
  VALUE_TYPES = [
    CustomField::TEXT_TYPE,
    CustomField::NUMBER_TYPE
  ].freeze

  OPTION_TYPES = [
    CustomField::SINGLE_SELECT_TYPE,
    CustomField::MULTI_SELECT_TYPE
  ].freeze

  belongs_to :user
  belongs_to :custom_field
  belongs_to :custom_field_option, optional: true

  validates :value, presence: true, if: -> { requires_value_by_type? }
  validates :custom_field_option_id, presence: true, if: -> { requires_option_by_type? }
  validate :validate_value_by_field_type

  private

  def requires_value_by_type?
    custom_field.present? && VALUE_TYPES.include?(custom_field.field_type)
  end

  def requires_option_by_type?
    custom_field.present? && OPTION_TYPES.include?(custom_field.field_type)
  end

  def validate_value_by_field_type
    return unless custom_field.present? && value.present?

    VALUE_TYPES.each do |field_type|
      send(:"validate_#{field_type}_field") if field_type == custom_field.field_type
    end
  end

  def validate_text_field
    errors.add(:value, 'must be a string') unless value.is_a?(String)
  end

  def validate_number_field
    unless value.to_s.match?(/\A-?\d+(\.\d+)?\z/)
      errors.add(:value, 'must be a valid number')
    end
  end
end