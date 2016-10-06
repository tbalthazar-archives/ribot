module RiBot
  class Bot
    def initialize(client = nil)
      @client = client
      @id = nil
      @dm_channel_ids = []
      @keyword = "ri"
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
      # puts "--- will inspect #{data.inspect}"
      return unless should_handle_message?(msg)
      puts "-- will handle #{msg.parse(@keyword)}"
    end

    def should_handle_message?(message)
      !message.is_empty? &&
        message.is_mention_to?(@id) ||
        message.is_in_dm_channel?(@dm_channel_ids) ||
        message.contains_keyword?(@keyword)
    end
  end
end
