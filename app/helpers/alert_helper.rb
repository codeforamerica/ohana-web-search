module AlertHelper
  def alert_tag(message)
    content_tag(:div, class: 'alert alert-error') do
      concat(content_tag :p, message, id: 'flash_error', class: 'alert-message')
      concat(content_tag(:a, class: 'alert-close', data: { dismiss: 'alert' }) do
        content_tag :i, nil, class: 'fa fa-times-circle fa-2x'
      end)
    end
  end
end
