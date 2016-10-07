module RiBot
  # Internal: This class interacts with the Slack API, receiving messages
  # and answering them.
  class Bot
    # Internal: Tthe String that will trigger the bot.
    TRIGGER = "ri"

    # Internal: Create a new Bot.
    #
    # client - The Slack::RealTime::Client that takes care of the realtime
    #          websocket connection.
    # ri     - The Ri object that will process ri commands.
    #
    # Examples
    #
    #   Bot.new(client, ri)
    def initialize(client = nil, ri = nil)
      @client = client
      @ri = ri
      @id = nil
      @name = ''
      @dm_channel_ids = []
    end

    # Internal: Start the Bot. It will connect to the Slack Realtime API and
    # listen to events.
    #
    # Examples
    #
    #   bot.start
    #
    # Returns nothing.
    def start
      @client.on :hello do
        @id = @client.self.id
        @name = @client.self.name
        @dm_channel_ids += @client.ims.keys
        say_welcome
      end
      
      @client.on :message do |data|
        handle_data(data)
      end
      
      @client.on :close do |_data|
        puts "Client is about to disconnect"
      end
      
      @client.on :closed do |_data|
        puts "Client has disconnected successfully!"
      end
      
      @client.start!
    end

    private

    # Internal: Handle the data received from the Slack API and reply with
    # either the result of the ri command, or  the usage instructions of
    # the bot.
    #
    # Examples
    #
    #   bot.handle_data(data)
    #
    # Returns nothing.
    def handle_data(data)
      msg = Message.new(data)
      return unless should_handle_message?(msg)

      arg = msg.parse(TRIGGER)
      text = case arg
             when "" then usage
             when "help" then usage("help")
             else @ri.execute(arg) 
             end
      text = usage(arg) if text.empty?

      send_text(data.channel, text)
    end

    # Internal: Determine if a message should be handled by the bot.
    #
    # message - The Message object that will be inspected.
    #
    # Examples
    #
    #   bot.should_handle_message?(message)
    #
    # Returns true if the message should be handled, false otherwise.
    def should_handle_message?(message)
      return false if message.is_hidden? || message.is_from?(@id) || message.is_from?("USLACKBOT")

      message.is_mention_to?(@id) ||
        message.is_in_channel?(@dm_channel_ids) ||
        message.contains_keyword?(TRIGGER)
    end

    # Internal: Send a message to a channel in Slack.
    #
    # channel - The String containing the channel id.
    # text    - The String containing the message to send.
    #
    # Examples
    #
    #   bot.send_text(channel, text)
    #
    # Returns nothing.
    def send_text(channel, text)
      @client.message channel: channel, text: text
    end

    # Internal: Get the list of channels the bot is watching.
    #
    # Examples
    #
    #   bot.channels
    #
    # Returns an array of channel name (beginning with the # sign)
    # the bot is watching.
    def channels
      ch = @client.channels.values
      ch.select { |c| !c.members.nil? && c.members.include?(@id) }.map { |c| "##{c.name}" }
    end

    # Internal: Display the bot usage instructions.
    #
    # arg - The String containing the argument that was used when trying to
    #       talk to the bot. It will be used to add some context to the help
    #       message.
    #
    # Examples
    #
    #   bot.usage(arg)
    #
    # Returns a message explaining how to interact with the bot.
    def usage(arg = '')
      usage = ""
      if arg.empty?
        usage += "Sorry, I don't understand your query. :sweat_smile:\n\n"
      elsif arg != "help"
        usage += "Sorry, I don't know what `#{arg}` is. :sweat_smile:\n\n"
      end

      chanlist = channels.empty? ? "none" : channels.join(", ")
      usage += "If you want me to help, please try one of the following:\n"
      usage += "In the channels where I've been invited (#{chanlist}), type one of the following commands:\n"
      usage += " - `#{TRIGGER} Array#sort`\n"
      usage += " - `@#{@name} Array#sort`\n"
      usage += "Or send me a direct message:\n"
      usage += " - `/msg @#{@name} Array#sort`\n"
    end

    # Internal: Display the welcome message to the console when the bot starts.
    # This is one of the most important method because it actually displays a
    # real bot. For real!
    #
    # Examples
    #
    #   bot.say_welcome
    #
    # Returns nothing.
    def say_welcome
      url = "https://#{@client.team.domain}.slack.com"
      str = %q(
                _____
               /_____\
          ____[\`---'/]____
         /\ #\ \_____/ /# /\
        /  \# \_.---._/ #/  \
       /   /|\  |   |  /|\   \      RiBot - The Ruby API Reference Bot
      /___/ | | |   | | | \___\
      |  |  | | |---| | |  |  |     Connected to _URL_ and waiting for your commands.
      |__|  \_| |_#_| |_/  |__|     To learn how to use it, type this command in Slack:
      //\\\\  <\ _//^\\\\_ />  //\\\\     /msg @_NAME_ help
      \||/  |\//// \\\\\\\\/|  \||/
            |   |   |   |           Hit CTRL+C to stop it.
            |---|   |---|
            |---|   |---|
            |   |   |   |
            |___|   |___|
            /   \   /   \
           |_____| |_____|
           |HHHHH| |HHHHH|

      )
      puts str.gsub("_URL_", url).gsub("_NAME_", @name)
    end
  end
end
