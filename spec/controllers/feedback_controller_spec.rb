require 'rails_helper'

describe FeedbackController do
  describe "POST 'create'" do
    it 'sends an email and redirects to root' do
      mailer = instance_double(ActionMailer::MessageDelivery, deliver_now: true)
      feedback_params = {
        agent: 'user-agent',
        from: 'me@test.com',
        message: 'hello'
      }
      allow(FeedbackMailer).to receive(:feedback_email).and_return(mailer)

      post :create, feedback_params

      expect(response).to redirect_to root_url
      expect(flash[:notice]).to eq 'Feedback Sent! Thank you!'
      expect(FeedbackMailer).
        to have_received(:feedback_email).with(feedback_params)
      expect(mailer).to have_received(:deliver_now)
    end
  end
end
