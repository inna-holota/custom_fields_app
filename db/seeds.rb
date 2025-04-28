tenant = Tenant.create!(name: 'Tenant A')

# Create a custom field for text
field_text = tenant.custom_fields.create!(name: 'bio', field_type: :text)

# Create a custom field for multi-select
field_multi_select = tenant.custom_fields.create!(name: 'roles', field_type: :multi_select)
field_multi_select.custom_field_options.create!(value: 'Admin')
field_multi_select.custom_field_options.create!(value: 'Editor')
field_multi_select.custom_field_options.create!(value: 'Viewer')
user = tenant.users.create!(first_name: 'John', last_name: 'Doe', email: 'john@example.com')

# Assign a value for the text field
user.custom_field_values.create!(custom_field: field_text, value: 'I love Ruby!')

# Assign multiple values for the multi-select field
CustomFieldValue.update_multi_select_values(user, field_multi_select, ['Admin', 'Editor'])
user.custom_field_values.for_field(user, field_multi_select).pluck(:value)
# => ['Admin', 'Editor']