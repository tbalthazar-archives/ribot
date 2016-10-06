module RiBot
  class Client
    def initialize(token = '', options = {})
      raise ArgumentError.new('Token cannot be blank') if token.nil? || token.strip.empty?

      options[:token] = token
      @bot = Bot.new(Slack::RealTime::Client.new(options))
    end

    def start
      @bot.start
    end
  end
end
