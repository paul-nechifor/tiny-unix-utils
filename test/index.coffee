require('chai').should()
{exec} = require 'child_process'

root = __dirname + '/..'

before (cb) ->
  exec """
    cd '#{root}'
    mkdir -p bin
    rsync -a --del src/ build-dir/
  """, cb

after (cb) ->
  exec """
    cd '#{root}'
    rm -fr build-dir bin
  """, cb
