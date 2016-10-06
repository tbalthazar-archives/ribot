module RiBot
  class Message
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

    def is_mention_to?(username)
      upcase_text.include?("<@#{username.upcase}>")
    end

    def contains_keyword?(keyword)
      keyword = keyword.upcase
      upcase_text == keyword ||
        upcase_text.start_with?("#{keyword} ")
    end

    def is_in_dm_channel?(channels)
      channels.map(&:upcase).include?(self.channel.upcase)
    end

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
