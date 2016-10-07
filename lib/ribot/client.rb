module RiBot
  # Public: This class is the entry point for the application. It takes care
  # of initializing all the objects needed by the bot before starting it.
  class Client
    # Public: Create a new Client.
    #
    # token   - The String containing the Slack API Token.
    # options - The Hash that contains the options passed to
    #           the Slack::RealTime::Client.
    #
    # Examples
    #
    #   Client.new('SlackTokenHere')
    def initialize(token = '', options = {})
      raise ArgumentError.new('Token cannot be blank') if token.nil? || token.strip.empty?

      options[:token] = token
      slack_client = Slack::RealTime::Client.new(options)
      ri_processor = Ri.new
      @bot = Bot.new(slack_client, ri_processor)
    end

    # Public: Start the Client. It will connect to the Slack Realtime API.
    #
    # Examples
    #
    #   client.start
    #
    # Returns nothing.
    def start
      @bot.start
    end
  end
end
