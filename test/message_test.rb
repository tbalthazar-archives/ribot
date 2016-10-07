require File.dirname(__FILE__) + '/helper'

class MessageTest < MiniTest::Test
  include RiBot::TestHelpers

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
    @msgs_with_keyword << RiBot::Message.new(FakeSlackMessage.new("#{@keyword}"))
    @msgs_with_keyword << RiBot::Message.new(FakeSlackMessage.new("#{@keyword} Array#first"))
    @msgs_with_keyword << RiBot::Message.new(FakeSlackMessage.new("#{@keyword.upcase} Array#first"))

    @msgs_without_keyword = []
    @msgs_without_keyword << RiBot::Message.new(FakeSlackMessage.new("#{@keyword}foo"))
    @msgs_without_keyword << RiBot::Message.new(FakeSlackMessage.new("foo #{@keyword} bar"))

    @channel = "FakeChannel"
    @channels = [@channel, "AnotherFakeChannel"]
    @msgs_in_dm_channel = []
    @msgs_in_dm_channel << RiBot::Message.new(FakeSlackMessage.new("Hey", @channel))
    @msgs_in_dm_channel << RiBot::Message.new(FakeSlackMessage.new("Hey", @channel.upcase))
    @msg_in_random_channel = RiBot::Message.new(FakeSlackMessage.new("Hey", "RandomChannel"))
  end

  def test_is_empty
    msgs = []
    msgs << RiBot::Message.new(FakeSlackMessage.new(""))
    msgs << RiBot::Message.new(FakeSlackMessage.new(" "))
    msgs << RiBot::Message.new(FakeSlackMessage.new("  "))

    msgs.each do |msg|
      assert msg.is_empty?, "'#{msg.text}' should be considered as empty"
    end

    msg = RiBot::Message.new(FakeSlackMessage.new("Hello"))
    refute msg.is_empty?, "'#{msg.text}' should not be considered as empty"
  end

  def test_is_hidden
    msg = RiBot::Message.new(FakeSlackMessage.new("Hello", "Channel", "User", true))
    assert msg.is_hidden?, "#{msg.inspect} should be considered as hidden"

    msg = RiBot::Message.new(FakeSlackMessage.new("Hello", "Channel", "User"))
    refute msg.is_hidden?, "#{msg.inspect} should not be considered as hidden"
  end

  def test_is_from
    user = "a_fake_user"
    msg = RiBot::Message.new(FakeSlackMessage.new("Hello", "Channel", user))
    assert msg.is_from?(user), "#{msg.inspect} should be considered as from #{user}"

    user2 = "another_fake_user"
    msg = RiBot::Message.new(FakeSlackMessage.new("Hello", "Channel", user2))
    refute msg.is_from?(user), "#{msg.inspect} should not be considered as from #{user}"
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
      assert msg.is_in_channel?(@channels), "#{msg.channel} should be detected in #{@channels}"
    end
    refute @msg_in_random_channel.is_in_channel?(@channels)
  end

  def test_parse
    values = [
      {in: "Hello bot! <@#{@username}>", out: 'Hello bot!'},
      {in: "<@#{@username}> Hello bot!", out: 'Hello bot!'},
      {in: "Hello <@#{@username}> bot!", out: 'Hello bot!'},
      {in: "<@#{@username}>", out: ''},
      {in: "#{@keyword} Hello bot!", out: 'Hello bot!'},
      {in: "<@#{@username}> #{@keyword} Hello bot!", out: 'Hello bot!'},
      {in: "#{@keyword} <@#{@username}> Hello bot!", out: 'Hello bot!'},
      {in: "#{@keyword} Hello bot! <@#{@username}>", out: 'Hello bot!'},
      {in: "<@#{@username}> Hello bot! <@anotheruser>", out: 'Hello bot!'},
      {in: "<@#{@username}> Hello bot! <@anotheruser> -i", out: 'Hello bot!'},
      {in: "<@#{@username}> Hello bot! <@anotheruser> --interactive", out: 'Hello bot!'},
    ]

    values.each do |value|
      message = RiBot::Message.new(FakeSlackMessage.new(value[:in]))
      assert_equal value[:out], message.parse(@keyword), "#{value[:in]} should be #{value[:out]} but is #{message.parse(@keyword)}"
    end
  end
end
