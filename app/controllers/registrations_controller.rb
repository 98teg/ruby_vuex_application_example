class RegistrationsController < RailsJwtAuth::RegistrationsController
  def registration_create_params
    params.require(RailsJwtAuth.model_name.underscore).permit(
      RailsJwtAuth.auth_field_name, :password, :password_confirmation, :name
    )
  end
end
