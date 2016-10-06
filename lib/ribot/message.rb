module RiBot
  class Message
    def initialize(data)
      @data = data
    end

    def text
      @data.text
    end

    def channel
      @data.channel
    end

    def is_mention_to?(username)
      upcase_text.include?("<@#{username.upcase}>")
    end

    def contains_keyword?(keyword)
      upcase_text.start_with?("#{keyword.upcase} ")
    end

    def is_in_dm_channel?(channels)
      channels.map(&:upcase).include?(self.channel.upcase)
    end

    private

    def upcase_text
      @upcase_text ||= text.upcase 
    end
  end
end
