module SearchHelper
  def only_smc_areas?
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

  def section_class_for(params)
    return 'toggle-container active' if params.present?
    'toggle-container'
  end
end
