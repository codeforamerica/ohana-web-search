module GoogleTranslator
  extend ActiveSupport::Concern

  included do
    before_action :write_translation_cookie, if: :translation_requested?
  end

  def write_translation_cookie
    delete_translation_cookies

    cookies[:googtrans] = {
      value: "/en/#{params[:translate]}",
      domain: "#{ENV['DOMAIN_NAME']}"
    }
  end

  def delete_translation_cookies
    cookies.delete(:googtrans, :domain => "#{ENV['DOMAIN_NAME']}")
    cookies.delete(:googtrans, :domain => ".#{ENV['DOMAIN_NAME']}")
    cookies.delete(:googtrans, :domain => "www.#{ENV['DOMAIN_NAME']}")
    cookies.delete(:googtrans, :domain => ".www.#{ENV['DOMAIN_NAME']}")
  end

  def translation_requested?
    params[:translate].present?
  end
end
