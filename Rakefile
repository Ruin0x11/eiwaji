require "bundler/gem_tasks"

task :ui do |t|
  sh "cd lib/ui/ && make && cd ../../"
end

task :run do
  sh "ruby -Ilib bin/eiwaji"
end
