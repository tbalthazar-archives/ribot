require 'rake/testtask'

Rake::TestTask.new do |t|
  t.warning = false
  t.libs << 'test'
  t.pattern = "test/**/*_test.rb"
end

desc "Run tests"
task :default => :test
