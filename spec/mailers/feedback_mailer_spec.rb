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

    it 'is delivered to the default email address(es)' do
      recipients = %w(anselm@codeforamerica.org
                      sophia@codeforamerica.org
                      moncef@codeforamerica.org
                      echan@co.sanmateo.ca.us
                      everducci@co.sanmateo.ca.us)
      expect(@email).to deliver_to(recipients)
    end

    it 'contains the correct message in the mail body' do
      expect(@email).to have_body_text(/testing/)
    end

    it 'has the correct subject' do
      expect(@email).to have_subject("[SMC Connect Feedback] #{@params[:from]}")
    end
  end

  context 'without an email address filled out' do
    before(:all) do
      @params = {
        message: 'no email address'
      }
      @email = FeedbackMailer.send_feedback(@params).deliver
    end

    it 'is delivered to the default email address(es)' do
      recipients = %w(anselm@codeforamerica.org
                      sophia@codeforamerica.org
                      moncef@codeforamerica.org
                      echan@co.sanmateo.ca.us
                      everducci@co.sanmateo.ca.us)
      expect(@email).to deliver_to(recipients)
    end

    it 'contains the correct message in the mail body' do
      expect(@email).to have_body_text(/no email address/)
    end

    it 'has the correct subject' do
      expect(@email).
        to have_subject('[SMC Connect Feedback] anonymous@none.com')
    end
  end
end
