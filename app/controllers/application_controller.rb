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

  def render_index(items)
    render json: {
      data: items.as_json(representation: :basic),
      meta: {
        total_count: items.total_count
      }
    }
  end

  def render_item(item)
    render json: {
      data: item.as_json(representation: :basic),
      meta: {}
    }
  end
end
