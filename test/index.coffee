fs = require 'fs'
require('chai').should()
{exec} = require 'child_process'

root = __dirname + '/..'

# Helper methods.
runCommands = (cmds, cb) ->
  exec cmds, (err, stdout, stderr) ->
    cb [
      if err is null then 0 else err.code
      stdout
    ]

runProgram = (program, cb) ->
  runCommands """
    cd '#{root}/bin'
    ./#{program}
  """, cb

runFromBin = (cmds, cb) ->
  runCommands """
    cd '#{root}/bin'
    #{cmds}
  """, cb

compileProgram = (name, cb) ->
  exec """
    cd '#{root}/build-dir'
    nasm -f bin -o ../bin/#{name} #{name}.asm
    chmod +x ../bin/#{name}
  """, cb

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

# All the tests.
describeProgram = (name, func) ->
  describe name, ->
    before (cb) ->
      compileProgram name, cb
    func()

describeProgram 'false', ->
  it 'should return 1', (done) ->
    runProgram 'false', (ret) ->
      ret.should.deep.equal [1, '']
      done()

describeProgram 'true', ->
  it 'should return 0', (done) ->
    runProgram 'true', (ret) ->
      ret.should.deep.equal [0, '']
      done()

describeProgram 'yes', ->
  it 'should write 1 y when requested and return 0', (done) ->
    runFromBin 'yes | head -n 1', (ret) ->
      ret.should.deep.equal [0, 'y\n']
      done()

describeProgram 'touch', ->
  it 'should touch one "asdf-fdsa" file', (done) ->
    runProgram 'touch asdf-fdsa', (ret) ->
      fs.readdir root + '/bin', (err, items) ->
        return done err if err
        items.should.contain 'asdf-fdsa'
        done()

  it 'should touch three files', (done) ->
    runProgram 'touch asdf001 asdf003 asdf002', (ret) ->
      fs.readdir root + '/bin', (err, items) ->
        return done err if err
        items.should.contain 'asdf001'
        items.should.contain 'asdf002'
        items.should.contain 'asdf003'
        done()
