class UsersController < ApplicationController
  before_action :set_user, only: [:update]

  def update
    results = CustomFields::Populate.new(@user, custom_field_values_params).call

    if all_results_successful?(results)
      render json: { success: true, message: 'Custom fields updated successfully', results: results }, status: :ok
    else
      render json: { success: false, message: 'Some custom fields failed to update', results: results }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: 'User not found' }, status: :not_found
  end

  def custom_field_values_params
    params.require(:custom_field_values).map do |field_value|
      field_value.permit(:custom_field_id, :value, :custom_field_option_id)
    end
  rescue ActionController::ParameterMissing
    render json: { success: false, message: 'Invalid custom field parameters' }, status: :bad_request
  end

  def all_results_successful?(results)
    results.all? { |result| result[:success] }
  end
end
