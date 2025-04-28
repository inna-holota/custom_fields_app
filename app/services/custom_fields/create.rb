module CustomFields
  class Create
    def initialize(tenant, params)
      @tenant = tenant
      @params = params
    end

    def call
      results = []

      params.each do |field_params|
        custom_field = if field_params[:id].present?
                         update_custom_field(field_params)
                       else
                         create_custom_field(field_params)
                       end

        results << {
          custom_field: custom_field,
          success: custom_field.persisted?,
          errors: Array(custom_field.errors.full_messages)
        }
      end

      results
    end

    private

    attr_reader :tenant, :params

    def custom_fields
      @custom_fields ||= tenant.custom_fields
    end

    def create_custom_field(field_params)
      custom_field = custom_fields.build(
        name: field_params[:name],
        field_type: field_params[:field_type]
      )
      if custom_field_requires_options?(field_params[:field_type])
        create_custom_field_options(custom_field, field_params[:values])
      end

      custom_field.save
      custom_field
    end

    def update_custom_field(field_params)
      custom_field = custom_fields.find_by(id: field_params[:id])

      return handle_not_fount unless custom_field

      custom_field.assign_attributes(
        name: field_params[:name],
        field_type: field_params[:field_type]
      )

      handle_custom_field_options(custom_field, field_params)
      custom_field.save
      custom_field
    end

    def custom_field_requires_options?(field_type)
      %w[single_select multi_select].include?(field_type)
    end

    def create_custom_field_options(custom_field, options)
      return unless options.is_a?(Array)

      options.each do |option_value|
        custom_field.custom_field_options.build(value: option_value[:value])
      end
    end

    def update_custom_field_options(custom_field, option_params)
      custom_field_options = custom_field.custom_field_options
      option_params.each do |option_param|
        option = custom_field_options.find_by(id: option_param[:id])
        next if option.blank?
        next if option.value == option_param[:value]

        option.update(value: option_param[:value])
      end
    end

    def handle_not_fount
      custom_field = custom_fields.build
      custom_field.errors.add(:base, 'CustomField not found')
      custom_field
    end

    def handle_custom_field_options(custom_field, field_params)
      if custom_field_requires_options?(field_params[:field_type]) && field_params[:values].present?
        existing_records, new_records = field_params[:values].partition { |record| record.key?(:id) }
        create_custom_field_options(custom_field, new_records)
        update_custom_field_options(custom_field, existing_records)
      end
    end
  end
end