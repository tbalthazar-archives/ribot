$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'minitest/autorun'
require 'ribot'

class FakeSlackMessage
  attr_accessor :text, :channel, :user, :hidden

  def initialize(text = 'A fake text', channel = 'A fake channel', user = 'A fake user', hidden = nil)
    @text = text
    @channel = channel
    @user = user
    @hidden = hidden
  end
end
