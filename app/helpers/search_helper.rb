module SearchHelper
  def all_service_areas?
    return true if params[:service_area] == 'smc'
    false
  end
end
