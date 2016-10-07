require File.dirname(__FILE__) + '/helper'

class BotTest < MiniTest::Test
  include RiBot::TestHelpers

  def setup
    @fake_client = FakeSlackClient.new
    @fake_ri = FakeRi.new
    # the bot is a member of this channel
    @channel_id = @fake_client.channels.keys.first
    # the id of the bot's direct message channel
    @dm_channel_id = @fake_client.ims.keys.first   
    # this is what should be extracted from a message and passed to the ri command
    @valid_ruby_method = "Array#sort"
    @text = @valid_ruby_method
    @text_with_mention = "<@#{@fake_client.self.id}> #{@valid_ruby_method}"
    @text_with_trigger = "#{RiBot::Bot::TRIGGER} #{@valid_ruby_method}"
    @text_with_mention_and_trigger = "<@#{@fake_client.self.id}> #{RiBot::Bot::TRIGGER} #{@valid_ruby_method}"
    @text_unknown = "Foobarwidgetacme"
    @text_help = "help"
    @help_text_excerpt = "If you want me to help"
    @bot = RiBot::Bot.new(@fake_client, @fake_ri)  
    @bot.start
  end

  def trigger_hello_event_silently
    capture_stdout do
      @fake_client.trigger_event(:hello)
    end
  end

  def assert_message_sent_in_channel(message, channel)
    assert_equal 1, @fake_client.messages.count
    assert_equal message, @fake_client.messages[channel].first
  end

  def test_hello
    slack_url = "https://#{@fake_client.team.domain}.slack.com"
    help_msg = "/msg @#{@fake_client.self.name} help"

    out = trigger_hello_event_silently

    assert out.include?(slack_url), "#{slack_url} should be included in #{out}"
    assert out.include?(help_msg), "#{help_msg} should be included in #{out}"
  end

  def test_close
    out = capture_stdout do
      @fake_client.trigger_event(:close)
    end

    assert_equal "Client is about to disconnect", out.chomp
  end

  def test_closed
    out = capture_stdout do
      @fake_client.trigger_event(:closed)
    end

    assert_equal "Client has disconnected successfully!", out.chomp
  end

  def test_valid_direct_message
    msg = FakeSlackMessage.new(@text, @dm_channel_id)
    trigger_hello_event_silently

    @fake_client.trigger_event(:message, msg)

    # @fake_ri.execute returns the arg it was passed, so we can test
    # the the arg was sent as a messgage. The arg should be the 
    # @valid_ruby_method extracted from @text
    assert_message_sent_in_channel(@valid_ruby_method, @dm_channel_id)
  end

  def test_mention
    msg = FakeSlackMessage.new(@text_with_mention, @channel_id)
    trigger_hello_event_silently

    @fake_client.trigger_event(:message, msg)

    # @fake_ri.execute returns the arg it was passed, so we can test
    # the the arg was sent as a messgage. The arg should be the 
    # @valid_ruby_method extracted from @text_with_mention
    assert_message_sent_in_channel(@valid_ruby_method, @channel_id)
  end

  def test_trigger
    msg = FakeSlackMessage.new(@text_with_trigger, @channel_id)
    trigger_hello_event_silently

    @fake_client.trigger_event(:message, msg)

    # @fake_ri.execute returns the arg it was passed, so we can test
    # the the arg was sent as a messgage. The arg should be the 
    # @valid_ruby_method extracted from @text_with_trigger
    assert_message_sent_in_channel(@valid_ruby_method, @channel_id)
  end

  def test_mention_and_trigger
    msg = FakeSlackMessage.new(@text_with_mention_and_trigger, @channel_id)
    trigger_hello_event_silently

    @fake_client.trigger_event(:message, msg)

    # @fake_ri.execute returns the arg it was passed, so we can test
    # the the arg was sent as a messgage. The arg should be the 
    # @valid_ruby_method extracted from @text_with_mention_and_trigger
    assert_message_sent_in_channel(@valid_ruby_method, @channel_id)
  end

  def test_unknown_ruby_method
    msg = FakeSlackMessage.new(@text_unknown, @dm_channel_id)
    trigger_hello_event_silently

    # Make @fake_ri.execute return "" to simulate an unknown ruby method.
    # In that case, the bot send the help message
    @fake_ri.stub :execute, "" do
      @fake_client.trigger_event(:message, msg)

      assert_equal 1, @fake_client.messages.count
      assert @fake_client.messages[@dm_channel_id].first.include?(@help_text_excerpt)
    end
  end

  def test_help
    msg = FakeSlackMessage.new(@text_help, @dm_channel_id)
    trigger_hello_event_silently

    @fake_client.trigger_event(:message, msg)

    assert_equal 1, @fake_client.messages.count
    assert @fake_client.messages[@dm_channel_id].first.include?(@help_text_excerpt)
  end
end
