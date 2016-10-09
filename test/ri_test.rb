require File.dirname(__FILE__) + '/helper'

class RiTest < MiniTest::Test
  include RiBot::TestHelpers

  def test_build_command
    arg = "Array#sort"
    ri = RiBot::Ri.new

    cmd = ri.build_command(arg)

    assert_equal "ri #{arg} --format=markdown 2>/dev/null", cmd
  end
end
