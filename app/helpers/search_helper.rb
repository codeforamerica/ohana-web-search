module SearchHelper
  def all_service_areas?
    return true if params[:service_area] == 'smc'
    false
  end

  def kind_options
    [
      'Arts', 'Clinics', 'Education', 'Entertainment', "Farmers' Markets",
      'Government', 'Human Services', 'Libraries', 'Museums', 'Other', 'Parks',
      'Sports'
    ]
  end

  def kind_selected?(kind)
    return false if params[:kind].blank?
    params[:kind].include?(kind)
  end

  def css_id_for(kind_option)
    "kind-#{kind_option.parameterize}"
  end
end
