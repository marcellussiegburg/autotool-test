require 'rake/testtask'

task default: [:test]

Rake::TestTask.new do |t|
  t.test_files = FileList['*Test.rb']
  t.verbose = true
end
