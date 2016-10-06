$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'ribot'

c = RiBot::Client.new(ENV['TOKEN'])
c.start
