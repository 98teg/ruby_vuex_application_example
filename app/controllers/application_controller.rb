class ApplicationController < ActionController::API
  include RailsJwtAuth::AuthenticableHelper
  include RailsAuthorize
end
