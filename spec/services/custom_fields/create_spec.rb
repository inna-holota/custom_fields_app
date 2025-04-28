require 'rails_helper'

RSpec.describe CustomFields::Create, type: :service do
  let(:tenant) { create(:tenant) }

  describe '#call' do
    context 'when creating a new custom field without options' do
      let(:params) do
        [
          {
            name: 'Status Field',
            field_type: 'text'
          }
        ]
      end

      it 'creates a custom field successfully' do
        service = CustomFields::Create.new(tenant, params)
        results = service.call

        expect(results).not_to be_empty
        result = results.first

        expect(result[:success]).to be(true)
        expect(result[:custom_field].name).to eq('Status Field')
        expect(result[:custom_field].field_type).to eq('text')
        expect(result[:errors]).to be_empty
      end
    end

    context 'when creating a new custom field with options' do
      let(:params) do
        [
          {
            name: 'Role Field',
            field_type: 'single_select',
            values: [
              { value: 'Admin' },
              { value: 'Editor' }
            ]
          }
        ]
      end

      it 'creates a custom field with its options successfully' do
        service = CustomFields::Create.new(tenant, params)
        results = service.call

        result = results.first
        expect(result[:success]).to be(true)

        custom_field = result[:custom_field]
        expect(custom_field.name).to eq('Role Field')
        expect(custom_field.field_type).to eq('single_select')
        expect(custom_field.custom_field_options.count).to eq(2)
        expect(custom_field.custom_field_options.map(&:value)).to match_array(['Admin', 'Editor'])
      end
    end

    context 'when updating an existing custom field' do
      let!(:custom_field) { create(:custom_field, tenant: tenant, name: 'Old Field', field_type: 'single_select') }
      let!(:option_1) { create(:custom_field_option, custom_field: custom_field, value: 'Viewer', id: 1) }
      let!(:option_2) { create(:custom_field_option, custom_field: custom_field, value: 'Editor', id: 2) }

      let(:params) do
        [
          {
            id: custom_field.id,
            name: 'Updated Field',
            field_type: 'multi_select',
            values: [
              { id: 1, value: 'Admin' }, # Updating existing option
              { value: 'New Option' }    # Creating a new option
            ]
          }
        ]
      end

      it 'updates the custom field and its options successfully' do
        service = CustomFields::Create.new(tenant, params)
        results = service.call

        result = results.first
        expect(result[:success]).to be(true)

        custom_field.reload
        expect(custom_field.name).to eq('Updated Field')
        expect(custom_field.field_type).to eq('multi_select')

        options = custom_field.custom_field_options
        expect(options.count).to eq(3) # One updated, one new
        expect(options.find_by(id: 1).value).to eq('Admin') # Updated option
        expect(options.find_by(value: 'New Option')).to be_present # New option
      end
    end

    context 'when updating a non-existent custom field' do
      let(:params) do
        [
          {
            id: 999, # Non-existent ID
            name: 'Non-existent Field',
            field_type: 'text'
          }
        ]
      end

      it 'returns an error for missing custom field' do
        service = CustomFields::Create.new(tenant, params)
        results = service.call

        result = results.first
        expect(result[:success]).to be(false)
        expect(result[:errors]).to include('CustomField not found')
        expect(result[:custom_field]).not_to be_persisted
      end
    end
  end
end