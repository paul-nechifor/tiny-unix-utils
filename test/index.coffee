require('chai').should()
{exec} = require 'child_process'

root = __dirname + '/..'

# Helper methods.
runCommands = (cmd, cb) ->
  exec cmd, (err, stdout, stderr) ->
    cb [
      if err is null then 0 else err.code
      stdout
    ]

runProgram = (program, cb) ->
  runCommands root + '/bin/' + program, cb

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
