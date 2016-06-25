require 'google/apis/translate_v2'

class KeywordTranslator
  attr_reader :keyword, :current_language, :target

  def initialize(keyword, current_language, target)
    @keyword = keyword
    @current_language = current_language
    @target = target
  end

  def translated_keyword
    return keyword if api_key.nil? || current_language == target || translations.blank?

    translations.first.translated_text
  end

  def original_keyword
    keyword
  end

  private

  def api_key
    ENV['GOOGLE_TRANSLATE_API_KEY']
  end

  def client
    @client ||= begin
      translate_service = Google::Apis::TranslateV2::TranslateService.new
      translate_service.key = api_key
      translate_service
    end
  end

  def result
    client.list_translations(keyword, target, format: 'text', source: current_language)
  end

  def translations
    result.translations if result.present?
  end
end
