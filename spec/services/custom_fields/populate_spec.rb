require 'rails_helper'

RSpec.describe CustomFields::Populate, type: :service do
  let!(:user) { create(:user) } # FactoryBot User object or equivalent
  let!(:custom_field_text) { create(:custom_field, field_type: 'text') }
  let!(:custom_field_single_select) { create(:custom_field, field_type: 'single_select') }
  let!(:custom_field_multi_select) { create(:custom_field, field_type: 'multi_select') }

  # Multi-select options
  let!(:multi_option_1) { create(:custom_field_option, custom_field: custom_field_multi_select, value: 'Option 1') }
  let!(:multi_option_2) { create(:custom_field_option, custom_field: custom_field_multi_select, value: 'Option 2') }
  let!(:multi_option_3) { create(:custom_field_option, custom_field: custom_field_multi_select, value: 'Option 3') }

  # Single select options
  let!(:single_option_1) { create(:custom_field_option, custom_field: custom_field_single_select, value: 'Option A') }

  describe '#call' do
    context 'when updating text fields' do
      let(:values) { [{ custom_field_id: custom_field_text.id, value: 'Updated Text Value' }] }

      it 'updates the text field value successfully' do
        service = CustomFields::Populate.new(user, values)
        results = service.call

        expect(results.count).to eq(1)
        result = results.first
        expect(result[:success]).to be(true)
        expect(result[:errors]).to be_empty

        field_value = user.custom_field_values.find_by(custom_field: custom_field_text)
        expect(field_value).to be_present
        expect(field_value.value).to eq('Updated Text Value')
      end
    end

    context 'when updating single select fields' do
      let(:values) { [{ custom_field_id: custom_field_single_select.id, custom_field_option_id: single_option_1.id }] }

      it 'updates the single select field successfully' do
        service = CustomFields::Populate.new(user, values)
        results = service.call

        expect(results.count).to eq(1)
        result = results.first
        expect(result[:success]).to be(true)
        expect(result[:errors]).to be_empty

        field_value = user.custom_field_values.find_by(custom_field: custom_field_single_select)
        expect(field_value).to be_present
        expect(field_value.custom_field_option_id).to eq(single_option_1.id)
      end
    end

    context 'when updating multi-select fields (adding selections)' do
      let(:values) do
        [
          { custom_field_id: custom_field_multi_select.id, custom_field_option_id: multi_option_1.id },
          { custom_field_id: custom_field_multi_select.id, custom_field_option_id: multi_option_2.id }
        ]
      end

      it 'adds multiple selections to the multi-select field' do
        service = CustomFields::Populate.new(user, values)
        results = service.call

        expect(results.count).to eq(2)
        results.each do |result|
          expect(result[:success]).to be(true)
          expect(result[:errors]).to be_empty
        end

        field_values = user.custom_field_values.where(custom_field: custom_field_multi_select)
        expect(field_values.count).to eq(2)
        expect(field_values.map(&:custom_field_option_id)).to match_array([multi_option_1.id, multi_option_2.id])
      end
    end

    context 'when updating multi-select fields (maintaining selections)' do\
      let!(:existing_value_1) { create(:custom_field_value, user: user, custom_field: custom_field_multi_select, custom_field_option: multi_option_1) }
      let!(:existing_value_2) { create(:custom_field_value, user: user, custom_field: custom_field_multi_select, custom_field_option: multi_option_2) }

      let(:values) do
        [
          { custom_field_id: custom_field_multi_select.id, custom_field_option_id: multi_option_1.id },
          { custom_field_id: custom_field_multi_select.id, custom_field_option_id: multi_option_2.id }
        ]
      end

      it 'maintains selections without duplicating them' do
        service = CustomFields::Populate.new(user, values)
        results = service.call

        expect(results.count).to eq(2)
        results.each do |result|
          expect(result[:success]).to be(true)
          expect(result[:errors]).to be_empty
        end

        field_values = user.custom_field_values.where(custom_field: custom_field_multi_select)
        expect(field_values.count).to eq(2)
        expect(field_values.map(&:custom_field_option_id)).to match_array([multi_option_1.id, multi_option_2.id])
      end
    end

    context 'when handling invalid custom field data' do
      let(:values) { [{ custom_field_id: 999, value: 'Invalid Field' }] }

      it 'returns an error for non-existent custom fields' do
        service = CustomFields::Populate.new(user, values)
        results = service.call

        expect(results.count).to eq(1)
        result = results.first
        expect(result[:success]).to be(false)
        expect(result[:errors]).to include('CustomField not found')
      end
    end

    context 'when attempting to update a field with invalid values' do
      let(:values) { [{ custom_field_id: custom_field_text.id }] }

      it 'returns validation errors for missing value' do
        service = CustomFields::Populate.new(user, values)
        results = service.call

        expect(results.count).to eq(1)
        result = results.first
        expect(result[:success]).to be(false)
        expect(result[:errors]).to include("Value can't be blank")
      end
    end
  end
end
