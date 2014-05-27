task :test do
  exec "bundle exec rspec spec && bundle exec cucumber"
end

task :t => :test
