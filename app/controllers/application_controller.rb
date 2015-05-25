class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  unless Rails.application.config.consider_all_requests_local
    rescue_from Faraday::ConnectionFailed, with: :render_api_down
    rescue_from Ohanakapa::ServiceUnavailable, with: :render_api_down
    rescue_from Ohanakapa::InternalServerError, with: :render_api_down
    rescue_from Ohanakapa::BadRequest, with: :render_bad_search
    rescue_from Ohanakapa::NotFound, with: :render_not_found
  end

  private

  def render_api_down
    redirect_to root_path, alert: t('errors.api_down')
  end

  def render_bad_search
    redirect_to path, alert: t('errors.bad_search')
  end

  def render_not_found
    redirect_to path, alert: t('errors.not_found')
  end

  def path
    referer = request.env['HTTP_REFERER']
    uri = request.env['REQUEST_URI']
    if referer.present? && referer != uri
      :back
    else
      root_path
    end
  end
end
