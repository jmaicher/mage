var_dir = "/var/mage"
sck_dir = "#{var_dir}/socket"
pid_dir = "#{var_dir}/pid"
log_dir = "#{var_dir}/log"

listen 3000
worker_processes 1

listen "#{sck_dir}/unicorn.sock", :backlog => 64
pid "#{pid_dir}/unicorn.pid"

timeout 30

