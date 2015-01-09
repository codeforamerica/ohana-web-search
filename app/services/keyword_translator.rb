require 'google/api_client'

class KeywordTranslator
  attr_reader :keyword, :current_language, :target, :format

  def initialize(keyword, current_language, target, format)
    @keyword = keyword
    @current_language = current_language
    @target = target
    @format = format
  end

  def api_key
    ENV['GOOGLE_TRANSLATE_API_KEY']
  end

  def client
    return if api_key.nil? || current_language == target
    Google::APIClient.new(key: api_key, authorization: nil)
  end

  def translate_api
    client.discovered_api('translate', 'v2') if client.present?
  end

  def params
    {
      format: format,
      source: current_language,
      target: target,
      q:      keyword
    }
  end

  def result
    return if client.nil?
    client.execute(
      api_method: translate_api.translations.list,
      parameters: params
    )
  end

  def translations
    result.data.translations if result.present?
  end

  def translated_keyword
    return keyword if translations.blank?
    translations.first.translatedText
  end

  def original_keyword
    keyword
  end
end
