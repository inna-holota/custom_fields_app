require 'rails_helper'

RSpec.describe CustomFieldValue, type: :model do
  let(:user) { create(:user) }
  let(:text_field) { create(:custom_field, field_type: 'text') }
  let(:number_field) { create(:custom_field, field_type: 'number') }
  let(:single_select_field) { create(:custom_field, field_type: 'single_select') }
  let(:multi_select_field) { create(:custom_field, field_type: 'multi_select') }
  let(:custom_field_option) { create(:custom_field_option, custom_field: single_select_field) }

  context 'validations' do
    it 'validates presence of value for text fields' do
      custom_field_value = CustomFieldValue.new(user: user, custom_field: text_field, value: nil)
      expect(custom_field_value).not_to be_valid
      expect(custom_field_value.errors[:value]).to include("can't be blank")
    end

    it 'validates presence of value for number fields' do
      custom_field_value = CustomFieldValue.new(user: user, custom_field: number_field, value: nil)
      expect(custom_field_value).not_to be_valid
      expect(custom_field_value.errors[:value]).to include("can't be blank")
    end

    it 'validates value is numeric for number fields' do
      custom_field_value = CustomFieldValue.new(user: user, custom_field: number_field, value: 'Not a number')
      expect(custom_field_value).not_to be_valid
      expect(custom_field_value.errors[:value]).to include('must be a valid number')
    end

    it 'validates presence of custom_field_option_id for single_select fields' do
      custom_field_value = CustomFieldValue.new(user: user, custom_field: single_select_field, custom_field_option_id: nil)
      expect(custom_field_value).not_to be_valid
      expect(custom_field_value.errors[:custom_field_option_id]).to include("can't be blank")
    end

    it 'validates presence of custom_field_option_id for multi_select fields' do
      custom_field_value = CustomFieldValue.new(user: user, custom_field: multi_select_field, custom_field_option_id: nil)
      expect(custom_field_value).not_to be_valid
      expect(custom_field_value.errors[:custom_field_option_id]).to include("can't be blank")
    end
  end
end