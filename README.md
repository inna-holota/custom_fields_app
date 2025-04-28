# Custom Fields API Documentation

## Assumptions
1. Each tenant can define custom fields of any type.
2. Users provide values for these custom fields, which can:
   - Be entered as text for `text` and `number` types.
   - Be selected from predefined options for `single_select` and `multi_select` types.
3. Multi-select fields allow users to select multiple options (stored as separate custom field values).
4. `CustomFieldValue` represents the input for a `User`, linked to the appropriate `CustomField`.
5. The system validates:
   - That `CustomField` exists for the provided ID.
   - Field types (`text`, `number`, `single_select`, `multi_select`) match the input data.

## API Endpoints
### UsersController
- `PATCH /users/:id/update`
  - Updates custom field values for a user.
  - Request body:
    ```json
    {
      "custom_field_values": [
        { 
          "custom_field_id": 1, 
          "value": "Sample Text"
        },
        { 
          "custom_field_id": 2, 
          "custom_field_option_id": 5
        },
        { 
          "custom_field_id": 3, 
          "custom_field_option_id": 6
        },
        { 
          "custom_field_id": 3, 
          "custom_field_option_id": 7
        }
      ]
    }
    
    ```
  - Response:
    ```json
    {
      "success": true,
      "message": "Custom fields updated successfully",
      "results": [
        {
          "success": true,
          "field_value": {
            "id": 1,
            "custom_field_id": 1,
            "value": "Sample Text",
            "custom_field_option_id": null
          },
          "errors": []
        },
        {
          "success": true,
          "field_value": {
            "id": 2,
            "custom_field_id": 2,
            "value": null,
            "custom_field_option_id": 5
          },
          "errors": []
        }
      ]
    }
        
    ```

### TenantsController
- `POST /tenants/:id/update`
  - Creates or updates custom fields for a tenant.
  - Request body:
    ```json
    {
      "custom_fields": [
        {
          "name": "Status",
          "field_type": "text"
        },
        { 
          "id": 2,
          "name": "Roles",
          "field_type": "multi_select",
          "values": [
            { "id": 3, "value": "Admin" },
            { "value": "Guest" }
          ]
        }
      ]
    }
    ```
  - Response:
    ```json
    {
      "success": true,
      "message": "Custom fields created/updated successfully",
      "results": [
        {
          "success": true,
          "custom_field": {
            "id": 1,
            "name": "Status",
            "field_type": "text",
            "custom_field_options": []
          },
          "errors": []
        },
        {
          "success": true,
          "custom_field": {
            "id": 2,
            "name": "Roles",
            "field_type": "multi_select",
            "custom_field_options": [
              { "id": 3, "value": "Admin" },
              { "id": 4, "value": "Guest" }
            ]
          },
          "errors": []
        }
      ]
    }
    ```