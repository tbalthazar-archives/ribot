$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'ribot'

b = RiBot::Bot.new(ENV['TOKEN'])
begin
  b.start
rescue StandardError => e
  puts "Error: #{e.inspect}"
end
