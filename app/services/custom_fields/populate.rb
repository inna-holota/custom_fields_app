module CustomFields
  class Populate
    def initialize(user, values)
      @user = user
      @values = values
    end

    def call
      results = []

      values.each do |value_params|
        result = update_or_create_value(value_params)
        results << result
      end

      results
    end

    private

    attr_reader :user, :values

    def update_or_create_value(value_params)
      custom_field = CustomField.find_by(id: value_params[:custom_field_id])
      return error_response('CustomField not found') unless custom_field.present?

      field_value = find_or_initialize_field_value(custom_field, value_params)

      update_field_value(field_value, value_params, custom_field.field_type)
    end

    def find_or_initialize_field_value(custom_field, value_params)
      case custom_field.field_type
      when 'text', 'number'
        user.custom_field_values.find_or_initialize_by(custom_field: custom_field)
      when 'single_select', 'multi_select'
        user.custom_field_values.find_or_initialize_by(
          custom_field: custom_field,
          custom_field_option_id: value_params[:custom_field_option_id]
        )
      else
        raise ArgumentError, "Unsupported field type: #{custom_field.field_type}"
      end
    end

    def update_field_value(field_value, value_params, field_type)
      case field_type
      when 'text', 'number'
        field_value.value = value_params[:value]
      when 'single_select', 'multi_select'
        field_value.custom_field_option_id = value_params[:custom_field_option_id]
      else
        return error_response('Invalid field type')
      end

      handle_result(field_value)
    end

    def handle_result(field_value)
      if field_value.save
        success_response(field_value: field_value)
      else
        error_response(field_value.errors.full_messages.join(', '))
      end
    end

    def success_response(field_value:)
      {
        success: true,
        field_value: field_value,
        errors: []
      }
    end

    def error_response(message)
      {
        success: false,
        field_value: nil,
        errors: [message]
      }
    end
  end
end