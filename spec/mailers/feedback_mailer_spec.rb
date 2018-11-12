require 'rails_helper'

describe FeedbackMailer do
  context 'with an email address filled out' do
    before(:all) do
      @params = {
        message: 'testing',
        from: 'tester@mctester.com',
        agent: 'Mozilla/5.0'
      }
      @email = FeedbackMailer.feedback_email(@params).deliver_now
    end

    it 'is delivered to the default email address(es)' do
      recipients = %w[echan@co.sanmateo.ca.us]
      expect(@email).to deliver_to(recipients)
    end

    it 'contains the correct message in the mail body' do
      expect(@email).to have_body_text(/testing/)
    end

    it 'has the correct subject' do
      expect(@email).to have_subject("[SMC-Connect Feedback] #{@params[:from]}")
    end

    it 'includes the user agent in the mail body' do
      expect(@email).to have_body_text(/Mozilla/)
    end

    it 'includes the referer in the mail body' do
      expect(@email).to have_body_text(/URL: lvh\.me/)
    end
  end

  context 'without an email address filled out and no user agent' do
    before(:all) do
      @params = {
        message: 'no email address'
      }
      @email = FeedbackMailer.feedback_email(@params).deliver_now
    end

    it 'is delivered to the default email address(es)' do
      recipients = %w[echan@co.sanmateo.ca.us]
      expect(@email).to deliver_to(recipients)
    end

    it 'contains the correct message in the mail body' do
      expect(@email).to have_body_text(/no email address/)
    end

    it 'specifies that no user agent was recorded' do
      expect(@email).to have_body_text(/no user agent/)
    end

    it 'includes anonymous@none.com in the subject' do
      expect(@email).
        to have_subject('[SMC-Connect Feedback] anonymous@none.com')
    end

    it 'sets the from field to anonymous@none.com' do
      expect(@email).to deliver_from('anonymous@none.com')
    end
  end
end
