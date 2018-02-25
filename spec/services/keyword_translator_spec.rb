require 'rails_helper'

describe KeywordTranslator do
  describe '#translated_keyword' do
    it 'returns keyword if api_key is nil' do
      translator = KeywordTranslator.new('ayuda', 'es', 'en')

      expect(translator.translated_keyword).to eq 'ayuda'
    end

    it 'returns keyword if current language is same as target' do
      allow(ENV).to receive(:[]).with('GOOGLE_TRANSLATE_API_KEY').and_return('abc123')
      translator = KeywordTranslator.new('ayuda', 'en', 'en')

      expect(translator.translated_keyword).to eq 'ayuda'
    end

    it 'returns keyword if translation service does not return any results' do
      allow(ENV).to receive(:[]).with('GOOGLE_TRANSLATE_API_KEY').and_return('abc123')
      service = FakeTranslator.new
      translator = KeywordTranslator.new('ayuda', 'es', 'en', service)

      expect(translator.translated_keyword).to eq 'ayuda'
    end

    it 'returns first translation result from translation service' do
      allow(ENV).to receive(:[]).with('GOOGLE_TRANSLATE_API_KEY').and_return('abc123')
      service = FakeTranslator.new('help')
      translator = KeywordTranslator.new('ayuda', 'es', 'en', service)

      expect(translator.translated_keyword).to eq 'help'
    end
  end

  describe '#original_keyword' do
    it 'returns the keyword argument' do
      translator = KeywordTranslator.new('ayuda', 'en', 'en')

      expect(translator.original_keyword).to eq 'ayuda'
    end
  end
end
