require 'spec_helper'

describe FeedbackMailer do
  context 'with an email address filled out' do
    before(:all) do
      @params = {
        message: 'testing',
        from:    'tester@mctester.com'
      }
      @email = FeedbackMailer.send_feedback(@params).deliver
    end

    it 'should be delivered to the default email address(es)' do
      recipients = %w(ohanapi@codeforamerica.org)
      expect(@email).to deliver_to(recipients)
    end

    it 'should contain the correct message in the mail body' do
      expect(@email).to have_body_text(/testing/)
    end

    it 'should have the correct subject' do
      expect(@email).
        to have_subject("[Ohana Web Search Feedback] #{@params[:from]}")
    end
  end

  context 'without an email address filled out' do
    before(:all) do
      @params = {
        message: 'no email address'
      }
      @email = FeedbackMailer.send_feedback(@params).deliver
    end

    it 'should be delivered to the default email address(es)' do
      recipients = %w(ohanapi@codeforamerica.org)
      expect(@email).to deliver_to(recipients)
    end

    it 'should contain the correct message in the mail body' do
      expect(@email).to have_body_text(/no email address/)
    end

    it 'should have the correct subject' do
      expect(@email).
        to have_subject('[Ohana Web Search Feedback] anonymous@none.com')
    end
  end
end
