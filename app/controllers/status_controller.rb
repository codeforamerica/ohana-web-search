class StatusController < ApplicationController
  respond_to :json

  def status
    # API checks
    test_location = Ohanakapa.location('redwood-city-free-medical-clinic')
    test_search = Ohanakapa.search(
      'search', keyword: 'ymca', kind: 'Human Services', service_area: 'smc'
    )

    if test_location.blank? || test_search.blank?
      status = 'API did not respond'
    else
      status = 'ok'
    end

    render json:
      {
        'status' => status,
        'updated' => Time.now.to_i,
        'dependencies' => ['Ohanakapa', 'Ohana API', 'Mandrill', 'MemCachier']
      }
  end
end
