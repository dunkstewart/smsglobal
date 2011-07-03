$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'smsglobal'
require 'rspec'
require 'webmock/rspec'

include SmsGlobal

RSpec.configure do |config|
  config.include WebMock::API
end

def stub_sms
  stub_request(:post, 'www.smsglobal.com/http-api.php')
end

def stub_sms_ok
  stub_sms.to_return(:body => "OK: 0; Sent queued message ID: 941596d028699601\nSMSGlobalMsgID:6764842339385521")
end

def stub_sms_failed
  stub_sms.to_return(:body => "ERROR: Missing parameter: from")
end
