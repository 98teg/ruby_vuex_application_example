class ApplicationController < ActionController::API
  include RailsJwtAuth::AuthenticableHelper
  include RailsAuthorize

  rescue_from RailsJwtAuth::NotAuthorized, with: :render_401
  rescue_from RailsAuthorize::NotAuthorizedError, with: :render_403

  def render_401
    head 401
  end

  def render_403
    head 403
  end
end
