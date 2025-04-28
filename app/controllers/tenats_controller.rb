class TenantsController < ApplicationController
  before_action :set_tenant, only: [:update]

  def update
    results = CustomFields::Create.new(@tenant, custom_fields_params).call

    if all_results_successful?(results)
      render json: { success: true, message: 'Custom fields created/updated successfully', results: results }, status: :ok
    else
      render json: { success: false, message: 'Some custom fields failed to be created or updated', results: results }, status: :unprocessable_entity
    end
  end

  private

  def set_tenant
    @tenant = Tenant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: 'Tenant not found' }, status: :not_found
  end

  def custom_fields_params
    params.require(:custom_fields).map do |field|
      field.permit(:id, :name, :field_type, values: [:id, :value])
    end
  rescue ActionController::ParameterMissing
    render json: { success: false, message: 'Invalid custom fields parameters' }, status: :bad_request
  end

  def all_results_successful?(results)
    results.all? { |result| result[:success] }
  end
end