module RiBot
  class Bot
    def initialize(client = nil)
      @client = client
      @id = nil
      @dm_channel_ids = []
      @keyword = "ri"
      @channels = {}
    end

    def start
      @client.on :hello do
        puts "#{@client.self.name} has connected to https://#{@client.team.domain}.slack.com and is waiting for your commands."
        @id = @client.self.id
        @dm_channel_ids += @client.ims.keys
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
      usage += " - `@#{@id} Array#sort`\n"
      usage += "Or send me a direct message:\n"
      usage += " - `/msg @#{@id} Array#sort`\n"
    end
  end
end
