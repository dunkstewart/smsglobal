require 'net/http'
require 'uri'

module SmsGlobal
  class Sender
    include Net
    
    Options = {}

    def initialize(options = {})
      @options = Sender::Options.merge(options)
      @base = options.delete(:base) || 'http://www.smsglobal.com/'
    end

    def send_text(request)
      @params = { :action => 'sendsms' }.merge(@options).merge(request)
      format_datetimes(:scheduledatetime)

      resp = post

      case resp
      when Net::HTTPSuccess
        if resp.body =~ /^OK: (\d+); ([^\n]+)\s+SMSGlobalMsgID:\s*(\d+)\s*$/
          return {
            :status  => :ok,
            :code    => $1.to_i,
            :message => $2,
            :id      => $3.to_i
          }
        elsif resp.body =~ /^ERROR: (.+)$/
          return {
            :status  => :error,
            :message => $1
          }
        else
          raise "Unable to parse response: '#{resp.body}'"
        end
      else
        return {
          :status  => :failed,
          :code    => resp.code,
          :message => 'Unable to reach SMSGlobal'
        }
      end
    end

  private
    
    def format_datetimes(*args)
      args.each do |key|
        @params[key] = @params[key].strftime('%Y-%m-%d %h:%M:%S') if @params[key]
      end
    end
    
    def post
      url = URI.join(@base, 'http-api.php')
      res = Net::HTTP.post_form url, @params
    end
  end
end