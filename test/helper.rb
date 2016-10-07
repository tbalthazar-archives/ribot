$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'minitest/autorun'
require 'ribot'

module RiBot
  module TestHelpers
    def capture_stdout(&block)
      original_stdout = $stdout
      $stdout = fake = StringIO.new
      begin
        yield
      ensure
        $stdout = original_stdout
      end
     fake.string
    end
    
    class FakeRi
      def execute(arg)
        arg 
      end
    end
    
    class FakeSlackMessage
      attr_accessor :text, :channel, :user, :hidden
    
      def initialize(text = 'A fake text', channel = 'A fake channel', user = 'A fake user', hidden = nil)
        @text = text
        @channel = channel
        @user = user
        @hidden = hidden
      end
    end
    
    class FakeSlackClient
      attr_reader :messages
    
      BOT_ID = "fake-bot-id"
    
      def initialize
        @events = {} 
        @messages = {}
      end
    
      def start!
      end
    
      def on(event, &block)
        @events[event] = block
      end
    
      def message(params)
        channel = params[:channel]
        @messages[channel] ||= []
        @messages[channel] << params[:text]
      end
    
      def trigger_event(event, data = nil)
        @events[event].call(data)
      end
    
      def self
    		@self ||= OpenStruct.new(:id => BOT_ID, :name => "fake-name")
      end
    
      def ims
        @ims ||= {
          "fake-key-1" => nil,
          "fake-key-2" => nil,
        }
      end
    
      def channels
        @channels ||= {
          "fake-channel-id-1" => OpenStruct.new(members: [BOT_ID, "fake-user-id-2"], name: "fake-channel-1"),
          "fake-channel-id-2" => OpenStruct.new(members: ["fake-user-id-1", "fake-user-id-2"], name: "fake-channel-2"),
        }
      end
    
      def team
        @team ||= OpenStruct.new(domain: "fake-domain") 
      end
    end
  end
end
