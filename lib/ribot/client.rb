module RiBot
  class Client
    def initialize(token = '', options = {})
      raise ArgumentError.new('Token cannot be blank') if token.nil? || token.strip.empty?

      options[:token] = token
      slack_client = Slack::RealTime::Client.new(options)
      ri_processor = Ri.new
      @bot = Bot.new(slack_client, ri_processor)
    end

    def start
      @bot.start
    end
  end
end
