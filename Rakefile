require "bundler/gem_tasks"

task :ui do |t|
  sh "cd lib/ui/ && make && cd ../../"
end

task :console do
  exec "irb -I ./lib -r eiwaji -r ./run.rb"
end
