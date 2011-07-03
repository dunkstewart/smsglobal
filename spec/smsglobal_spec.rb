require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'SmsGlobal' do
  include SmsGlobal

  describe 'Sender' do
    before do
      @sender = Sender.new :user => 'DUMMY', :password => 'DUMMY'
    end

    it "sends SMS correctly" do
      stub_sms_ok
      resp = @sender.send_text :text => 'Lorem Ipsum', :to => '12341324', :from => '1234'
      resp[:status].should == :ok
      resp[:code].should == 0
      resp[:message].should == 'Sent queued message ID: 941596d028699601'
    end

    it "gracefully fails" do
      stub_sms_failed
      resp = @sender.send_text :text => 'Lorem Ipsum', :to => '12341324', :from => '1234'
      resp[:status].should == :error
      resp[:message].should == 'Missing parameter: from'
    end

    it "posts the correct data" do
      stub_sms_ok.with(:body => { :action => 'sendsms', :user => 'DUMMY', :password => 'DUMMY', :text => 'xyz', :to => '1234', :from => '5678' })
      @sender.send_text :text => 'xyz', :to => '1234', :from => '5678'
    end

    it "gracefully fails on connection error" do
      stub_sms.to_return(:status => [500, "Internal Server Error"])
      resp = @sender.send_text :text => 'xyz', :to => '1234', :from => '5678'
      resp[:status].should == :failed
      resp[:message].should == "Unable to reach SMSGlobal"
    end
    
    it 'should format scheduledatetime' do
      
    end
  end
end
