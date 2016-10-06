module RiBot
  class Bot
    def initialize(client = nil)
      @client = client
      @id = nil
      @name = ''
      @dm_channel_ids = []
      @keyword = "ri"
      @channels = {}
    end

    def start
      @client.on :hello do
        @id = @client.self.id
        @name = @client.self.name
        @dm_channel_ids += @client.ims.keys
        welcome
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

    def handle_data(data)
      msg = Message.new(data)
      return unless should_handle_message?(msg)

      arg = msg.parse(@keyword)
      text = case arg
             when "" then usage
             when "help" then usage("help")
             else Ri.execute(arg) 
             end
      text = usage(arg) if text.empty?

      send_text(data.channel, text)
    end

    def should_handle_message?(message)
      return false if message.is_hidden? || message.is_from?(@id) || message.is_from?("USLACKBOT")

      message.is_mention_to?(@id) ||
        message.is_in_dm_channel?(@dm_channel_ids) ||
        message.contains_keyword?(@keyword)
    end

    def send_text(channel, text)
      @client.message channel: channel, text: text
    end

    def channels
      ch = @client.channels.values
      ch.select { |c| !c.members.nil? && c.members.include?(@id) }.map { |c| "##{c.name}" }
    end

    def usage(arg = '')
      usage = ""
      if arg.empty?
        usage += "Sorry, I don't understand your query. :sweat_smile:\n\n"
      elsif arg != "help"
        usage += "Sorry, I don't know what `#{arg}` is. :sweat_smile:\n\n"
      end

      usage += "If you want to talk, please try one of the following:\n"
      usage += "In the channels where I've been invited (#{channels.join(", ")}), type one of the following commands:\n"
      usage += " - `ri Array#sort`\n"
      usage += " - `@#{@name} Array#sort`\n"
      usage += "Or send me a direct message:\n"
      usage += " - `/msg @#{@name} Array#sort`\n"
    end

    def welcome
      url = "https://#{@client.team.domain}.slack.com"
      str = %q(
                _____
               /_____\
          ____[\`---'/]____
         /\ #\ \_____/ /# /\
        /  \# \_.---._/ #/  \
       /   /|\  |   |  /|\   \      RiBot - The Ruby API Reference Bot
      /___/ | | |   | | | \___\
      |  |  | | |---| | |  |  |     Connected to _URL_ and is waiting for your commands.
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
