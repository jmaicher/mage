task :server do
  # optional port parameter
  port = ENV['PORT'] ? ENV['PORT'] : '3000'
  config = 'config/unicorn.rb'

  puts "Starting unicorn in development mode on port #{port}...\n\n"
  exec "cd #{Rails.root} && RAILS_ENV=development unicorn -p #{port} -c #{config}"
end

task :s => :server

