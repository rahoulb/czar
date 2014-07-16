require "bundler/gem_tasks"
require 'rake/testtask'
require 'minitest/autorun'

Rake::TestTask.new do |t|
 t.libs << 'test'
 t.test_files = Dir["test/**/*_test.rb"]
end

desc "Run tests"
task :default => :test
