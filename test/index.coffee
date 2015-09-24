require('chai').should()
{exec} = require 'child_process'

# Helper methods.
run = (cmd, cb) ->
  exec cmd, (err, stdout, stderr) ->
    cb [
      if err is null then 0 else err.code
      stdout
    ]

describe 'true', ->
  it 'should return 0', (done) ->
    run './bin/true', (ret) ->
      ret.should.deep.equal [0, '']
      done()

describe 'false', ->
  it 'should return 1', (done) ->
    run './bin/false', (ret) ->
      ret.should.deep.equal [1, '']
      done()
