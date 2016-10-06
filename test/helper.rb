$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'minitest/autorun'
require 'ribot'

class FakeSlackMessage
  attr_accessor :text, :channel, :user

  def initialize(text = 'A fake text', channel = 'A fake channel', user = 'A fake user')
    @text = text
    @channel = channel
    @user = user
  end
end
