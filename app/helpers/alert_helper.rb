module AlertHelper
  def alert_tag(flash)
    return alert_content_for('error', nil) unless flash
    safe_join(
      flash.map { |type, message| alert_content_for(type, message) }
    )
  end

  def alert_content_for(type, message)
    content_tag(:div, class: "alert alert-#{type}") do
      concat(content_tag(:p, message, id: "flash_#{type}", class: 'alert-message'))
      concat(content_tag(:a, class: 'alert-close', data: { dismiss: 'alert' }) do
        content_tag :i, nil, class: 'fa fa-times-circle fa-2x'
      end)
    end
  end
end
