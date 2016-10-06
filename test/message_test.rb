require File.dirname(__FILE__) + '/helper'

class MessageTest < MiniTest::Test

  def setup
    @username = "FakeUsername"
    @msgs_with_mention = []
    @msgs_with_mention << RiBot::Message.new(FakeSlackMessage.new("Hello bot! <@#{@username}>"))
    @msgs_with_mention << RiBot::Message.new(FakeSlackMessage.new("<@#{@username}> Hello bot!"))
    @msgs_with_mention << RiBot::Message.new(FakeSlackMessage.new("Hello <@#{@username}> bot!"))
    @msgs_with_mention << RiBot::Message.new(FakeSlackMessage.new("<@#{@username}>"))
    @msgs_with_mention << RiBot::Message.new(FakeSlackMessage.new("<@#{@username.upcase}>"))

    @keyword = "FakeKeyword"
    @msgs_with_keyword = []
    @msgs_with_keyword << RiBot::Message.new(FakeSlackMessage.new("#{@keyword} Array#first"))
    @msgs_with_keyword << RiBot::Message.new(FakeSlackMessage.new("#{@keyword.upcase} Array#first"))

    @msgs_without_keyword = []
    @msgs_without_keyword << RiBot::Message.new(FakeSlackMessage.new("#{@keyword}"))
    @msgs_without_keyword << RiBot::Message.new(FakeSlackMessage.new("#{@keyword}foo"))
    @msgs_without_keyword << RiBot::Message.new(FakeSlackMessage.new("foo #{@keyword} bar"))

    @channel = "FakeChannel"
    @channels = [@channel, "AnotherFakeChannel"]
    @msgs_in_dm_channel = []
    @msgs_in_dm_channel << RiBot::Message.new(FakeSlackMessage.new("Hey", @channel))
    @msgs_in_dm_channel << RiBot::Message.new(FakeSlackMessage.new("Hey", @channel.upcase))
    @msg_in_random_channel = RiBot::Message.new(FakeSlackMessage.new("Hey", "RandomChannel"))
  end

  def test_is_mention_to
    @msgs_with_mention.each do |msg|
      assert msg.is_mention_to?(@username), "#{msg.text} should be considered as a mention to #{@username}"
    end
  end

  def test_contains_keyword
    @msgs_with_keyword.each do |msg|
      assert msg.contains_keyword?(@keyword), "#{@keyword} should have been detected in #{msg.text}"
    end
  end

  def test_do_not_contain_keyword
    @msgs_without_keyword.each do |msg|
      refute msg.contains_keyword?(@keyword), "#{@keyword} should not have been detected in #{msg.text}"
    end
  end

  def test_is_in_dm_channel
    @msgs_in_dm_channel.each do |msg|
      assert msg.is_in_dm_channel?(@channels), "#{msg.channel} should be detected in #{@channels}"
    end
    refute @msg_in_random_channel.is_in_dm_channel?(@channels)
  end
end
