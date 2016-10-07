require File.dirname(__FILE__) + '/helper'

class ClientTest < MiniTest::Test
  def test_new_client_without_token_raises_an_error
    [nil, '', '  '].each do |token|
      assert_raises ArgumentError do
        RiBot::Client.new(token)
      end
    end
  end

  def test_new_client_with_token_does_not_raise_an_error
    RiBot::Client.new("a-fake-token")
  end
end
