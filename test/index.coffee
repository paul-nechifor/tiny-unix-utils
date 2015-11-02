fs = require 'fs'
require('chai').should()
tools = require './tools'
{exec} = require 'child_process'

root = __dirname + '/..'

# Move the tests, create `bin/` and a copy of `src/`.
before (cb) ->
  exec """
    cd '#{root}'
    mkdir -p bin
    rsync -a --del src/ build-dir/
  """, cb

# After the tests, remove the dirs created above.
after (cb) ->
  exec """
    cd '#{root}'
    rm -fr build-dir bin
  """, cb

# Make everything in tools global. Maybe I should just replace this with a
# single global variable.
for name, value of tools
  global[name] = value

# Wrap all the other files in this dir in a `describe` call.
for file in fs.readdirSync __dirname
  continue if file.indexOf('.coffee') is -1
  name = file.replace '.coffee', ''
  continue if name is 'index' or name is 'tools'
  do (name) ->
    descFunc = if name.indexOf('_') is 0 then describe else describeProgram
    descFunc name, ->
      require './' + name
