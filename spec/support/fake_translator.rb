class FakeTranslator
  Translations = Struct.new(:translations)
  Translation = Struct.new(:translated_text)

  def initialize(translation = nil)
    @translation = translation
  end

  def list_translations(_keyword, _target, _options = {})
    return Translations.new([Translation.new(translation)]) if translation.present?

    Translations.new([])
  end

  private

  attr_reader :translation
end
