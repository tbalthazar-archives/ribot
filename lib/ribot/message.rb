module RiBot
  # Internal: This class encapsulates a message received form Slack and
  # provides a few utility methods.
  class Message
    # Internal: Create a new Message.
    #
    # data - The Hashie::Hash containing the raw message data.
    #
    # Examples
    #
    #   Message.new(data)
    def initialize(data)
      @data = data
    end

    def text
      @data.text || ''
    end

    def channel
      @data.channel
    end

    def user
      @data.user
    end

    def is_empty?
      text.strip.empty?
    end

    def is_hidden?
      @data.hidden == true
    end

    def is_from?(username)
      user.upcase == username.upcase
    end

    # Internal: Detect if a message is a Slack mention to a user.
    #
    # username - The String username to look for.
    #
    # Examples
    #
    #   msg = Message.new(data)
    #   msg.is_mention_to?("johndoe")
    #
    # Returns true if the message is a mention of username, false otherwise.
    def is_mention_to?(username)
      upcase_text.include?("<@#{username.upcase}>")
    end

    # Internal: Detect if a message contains a trigger for the bot.
    #
    # trigger - The String trigger to look for.
    #
    # Examples
    #
    #   msg = Message.new(data)
    #   msg.contains_trigger?("ri")
    #
    # Returns true if the message contains the trigger, false otherwise.
    def contains_trigger?(trigger)
      trigger = trigger.upcase
      upcase_text == trigger ||
        upcase_text.start_with?("#{trigger} ")
    end

    # Internal: Detect if a message has been sent in one of the given channels.
    #
    # channels - The Array containing the channels to look for.
    #
    # Examples
    #
    #   msg = Message.new(data)
    #   msg.is_in_channel?("channel1")
    #
    # Returns true if the message belongs to one of the channels,
    # false otherwise.
    def is_in_channel?(channels)
      channels.map(&:upcase).include?(channel.upcase)
    end

    # Internal: Strip the text of the message from the keyword, mentions
    # and flags.
    #
    # keyword - The String keyword that has to be removed from the text.
    #
    # Examples
    #
    #   msg = Message.new(data)
    #   msg.parse("ri")
    #
    # Returns the cleaned up text.
    def parse(keyword)
      txt = text.gsub(keyword, "")          # removes the keyword (e.g: 'ri') from the string
      txt = txt.gsub(/\<\@[^>]+\>\s?/, "")  # removes all the <@mentions>
      txt = txt.gsub(/\-+[^\s]*/, "")       # removes all the flags (e.g: '-i' or '--interactive')
      txt.strip
    end

    private

    def upcase_text
      @upcase_text ||= text.upcase 
    end
  end
end
