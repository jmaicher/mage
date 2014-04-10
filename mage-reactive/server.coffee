http = require 'http'
sockjs = require 'sockjs'
host = '0.0.0.0'
port = 7000

echo = sockjs.createServer()

echo.on 'connection', (conn) ->
  console.log "WAT"
  conn.on 'data', (message) ->
    conn.write message

server = http.createServer()
echo.installHandlers(server, prefix:'/echo')

console.log "Listening on #{host}:#{port}"
server.listen port

