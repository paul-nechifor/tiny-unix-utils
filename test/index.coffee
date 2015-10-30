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

describeProgram 'cat', ->
  it 'should work with a single character', (done) ->
    runFromBin 'echo -n a | ./cat', (ret) ->
      ret.should.deep.equal [0, 'a']
      done()
  it 'should work with a new lines', (done) ->
    runFromBin 'echo word1 word2 | ./cat', (ret) ->
      ret.should.deep.equal [0, 'word1 word2\n']
      done()
  it 'should work with large files', (done) ->
    x10000 = ('x' for x in [1 .. 10000]).join ''
    runFromBin "echo -n #{x10000} | ./cat", (ret) ->
      ret.should.deep.equal [0, x10000]
      done()

describeProgram 'wc', ->
  it 'should work with no characters', (done) ->
    runFromBin 'echo -n | ./wc', (ret) ->
      ret.should.deep.equal [0, '0 0 0\n']
      done()
  it 'should work with a single character', (done) ->
    runFromBin 'echo -n a | ./wc', (ret) ->
      ret.should.deep.equal [0, '1 0 0\n']
      done()
  it 'should work with a larger file', (done) ->
    x12345 = ('x' for x in [1 .. 12345]).join ''
    runFromBin "echo -n #{x12345} | ./wc", (ret) ->
      ret.should.deep.equal [0, '12345 1 0\n']
      done()
  it 'should work with a single line', (done) ->
    runFromBin "echo hello | ./wc", (ret) ->
      ret.should.deep.equal [0, '6 1 1\n']
      done()

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
