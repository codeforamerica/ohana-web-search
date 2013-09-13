require "spec_helper"

describe FeedbackMailer do
  context "with an email address filled out" do
    before(:all) do
      @params = {
        :message => "testing",
        :from    => "tester@mctester.com"
      }
      @email = FeedbackMailer.send_feedback(@params).deliver
    end

    it "should be delivered to the default email address(es)" do
      recipients = "anselm@codeforamerica.org, sophia@codeforamerica.org,"
      recipients << "moncef@codeforamerica.org"
      @email.should deliver_to(recipients)
    end

    it "should contain the correct message in the mail body" do
      @email.should have_body_text(/testing/)
    end

    it "should have the correct subject" do
      @email.should have_subject("[SMC Connect Feedback] #{@params[:from]}")
    end
  end

  context "without an email address filled out" do
    before(:all) do
      @params = {
        :message => "no email address"
      }
      @email = FeedbackMailer.send_feedback(@params).deliver
    end

    it "should be delivered to the default email address(es)" do
      recipients = "anselm@codeforamerica.org, sophia@codeforamerica.org,"
      recipients << "moncef@codeforamerica.org"
      @email.should deliver_to(recipients)
    end

    it "should contain the correct message in the mail body" do
      @email.should have_body_text(/no email address/)
    end

    it "should have the correct subject" do
      @email.should have_subject("[SMC Connect Feedback] anonymous@none.com")
    end
  end

end