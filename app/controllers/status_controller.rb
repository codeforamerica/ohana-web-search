class StatusController < ApplicationController
  def check_status
    response_hash = {}
    response_hash[:dependencies] = %w(Mandrill Memcachier)
    response_hash[:status] = everything_ok? ? 'ok' : 'NOT OK'
    response_hash[:updated] = Time.zone.now.to_i

    render json: response_hash
  end

  private

  def everything_ok?
    fetch_location_okay? && search_okay?
  end

  def fetch_location_okay?
    Ohanakapa.location('redwood-city-free-medical-clinic').present?
  end

  def search_okay?
    Ohanakapa.search('search', keyword: 'ymca', kind: 'Human Services',
                               service_area: 'smc').present?
  end
end
