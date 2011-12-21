require 'spec_helper'

describe "Sendgrid Event API" do
  describe "WebHook" do

    before(:all) do
      @lead_mail = Factory(:lead_mail)
    end

    it "fails if the event received is invalid" do
      post hooks_path, {:event => :invalid, :email => "emailrecipient@domain.com"}
      response.status.should_not be(200)
    end

    it "fails if the email received does not exists" do
      post hooks_path, {:event => :processed, :email => "emailrecipient@domain.com"}
      response.status.should_not be(200)
    end

    it "sets the correct state in a LeadMail when the email delivery status changes" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      post hooks_path, {:event => :processed, :email => @lead_mail.email}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).state.should == "processed"

      post hooks_path, {:event => :deferred, :email => @lead_mail.email}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).state.should == "deferred"

      post hooks_path, {:event => :delivered, :email => @lead_mail.email}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).state.should == "delivered"

      post hooks_path, {:event => :dropped, :email => @lead_mail.email}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).state.should == "dropped"

      post hooks_path, {:event => :bounce, :email => @lead_mail.email}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).state.should == "bounce"

    end

    it "updates a LeadMail when the lead opens the email" do
      post hooks_path, {:event => :open, :email => @lead_mail.email}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).opened.should be_true
    end

    it "updates a LeadMail when the lead mark the message as spam" do
      post hooks_path, {:event => :spamreport, :email => @lead_mail.email}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).is_spam.should be_true
    end

    it "updates a LeadMail when the lead unsubscribes" do
      post hooks_path, {:event => :unsubscribe, :email => @lead_mail.email}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).unsubscribed.should be_true
    end

    it "updates a LeadMail when the lead clicks in a url in the message and saves the url" do
      post hooks_path, {:event => :click, :email => @lead_mail.email, :url => "http://www.example.com/"}
      response.status.should be(200)
      LeadMail.find_by_email(@lead_mail.email).clicks.include?("http://www.example.com/").should be_true
    end

  end
end
