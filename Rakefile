require 'rake'
require 'rake/testtask'

task :default => [:test]

desc "Run basic tests"

Rake::TestTask.new( "test" ) { |task|
    task.pattern = 'testsuite/*_test.rb'
    task.verbose = true
    task.warning = true
    task.libs << 'lib'
}
