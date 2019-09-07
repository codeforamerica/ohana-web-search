require 'rails_helper'

describe Feedback do
  describe '#valid?' do
    context 'missing message' do
      it 'is not valid' do
        feedback = Feedback.new(email: '', message: '', recaptcha: true)

        expect(feedback).to_not be_valid
        expect(feedback.error).to eq 'Please fill out the comments field'
      end
    end

    context 'email in wrong format' do
      it 'is not valid' do
        feedback = Feedback.new(email: 'foo', message: 'test', recaptcha: true)

        expect(feedback).to_not be_valid
        expect(feedback.error).to eq 'Please fill in a valid email'
      end
    end

    context 'recaptcha is false' do
      it 'is not valid' do
        feedback = Feedback.new(email: '', message: 'test', recaptcha: false)

        expect(feedback).to_not be_valid
        expect(feedback.error).to be_nil
      end
    end

    context 'message is present but email is missing' do
      it 'is valid' do
        feedback = Feedback.new(email: '', message: 'test', recaptcha: true)

        expect(feedback).to be_valid
        expect(feedback.error).to be_nil
      end
    end
  end
end
