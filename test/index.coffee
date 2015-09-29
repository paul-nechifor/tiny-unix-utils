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
    ../scripts/a #{name}.asm --debug
    cp #{name} ../bin
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

# describeProgram 'touch', ->
#   it 'should touch one "asdf-fdsa" file', (done) ->
#     runProgram 'touch asdf-fdsa', (ret) ->
#       fs.readdir root + '/bin', (err, items) ->
#         return done err if err
#         items.should.contain 'asdf-fdsa'
#         done()

#   it 'should touch three files', (done) ->
#     runProgram 'touch asdf001 asdf003 asdf002', (ret) ->
#       fs.readdir root + '/bin', (err, items) ->
#         return done err if err
#         items.should.contain 'asdf001'
#         items.should.contain 'asdf002'
#         items.should.contain 'asdf003'
#         done()

class Template
  constructor: (@name, @str) ->

  run: (replace, cb) ->
    str = @str
    for key, value of replace
      str = str.replace "{{ #{key} }}", value
    newName = @name.replace '.tpl.asm', ''
    fs.writeFileSync root + '/build-dir/' + newName + '.asm', str
    compileProgram newName, (err) ->
      return cb err if err
      runProgram newName, cb

loadTemplate = (path) ->
  new Template path, fs.readFileSync root + '/src/' + path, encoding: 'utf8'

describe '_u64_to_str', ->
  template = loadTemplate '_u64_to_str_test.tpl.asm'
  numbersToTest = [0, 1, 7, 13, 432, 12345, 123456, '18446744073709551615']
  for n in numbersToTest
    do (n) ->
      it 'should show ' + n, (done) ->
        template.run {number: '' + n}, (ret) ->
          ret.should.deep.equal [0, '' + n]
          done()
