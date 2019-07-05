class ApplicationController < ActionController::API
  include RailsJwtAuth::AuthenticableHelper
end
