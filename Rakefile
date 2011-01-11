require 'rake'
require 'rake/testtask'

task :default => [:test_units]

desc "Run basic tests"
Dir.chdir( './lib' )
Rake::TestTask.new( "test_units" ) { |task|
    task.pattern = '../testsuite/*test.rb'
    task.verbose = true
    task.warning = true
    task.libs << '../lib'
}

