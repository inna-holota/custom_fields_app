class CustomFieldValue < ApplicationRecord
  belongs_to :user
  belongs_to :custom_field
  belongs_to :custom_field_option, optional: true 

  validates :value, presence: true, unless: -> { custom_field_option.present? }

  # Scope to retrieve multi-select values for a specific user and field
  scope :for_field, ->(user, field) { where(user: user, custom_field: field) }

  # Utility method to handle multi-select values
  def self.update_multi_select_values(user, field, values)
    transaction do
      # Delete existing values for the multi-select field
      for_field(user, field).delete_all

      # Insert new values
      values.each do |value|
        create!(user: user, custom_field: field, value: value)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e.message)
    raise e
  end
  def valid_value?(field_type)
    case field_type
    when 'text'
      value.is_a?(String)
    when 'number'
      value =~ /\A\d+\z/ # Ensure value is numeric
    when 'single_select', 'multi_select'
      custom_field_option.present? # Value must point to a valid option(s)
    else
      false
    end
  end
end
