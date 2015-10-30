fs = require 'fs'
{exec} = require 'child_process'

root = __dirname + '/..'

exports.runCommands = runCommands = (cmds, cb) ->
  exec cmds, (err, stdout, stderr) ->
    cb [
      if err is null then 0 else err.code
      stdout
    ]

exports.runFromBin = runFromBin = (cmds, cb) ->
  runCommands """
    cd '#{root}/bin'
    #{cmds}
  """, cb

exports.compileProgram = compileProgram = (name, cb) ->
  exec """
    cd '#{root}/build-dir'
    ../scripts/a #{name}.asm --debug
    cp #{name} ../bin
  """, cb

exports.describeProgram = (name, func) ->
  describe name, ->
    before (cb) ->
      compileProgram name, cb
    func()

exports.Template = Template = class
  constructor: (@name, @str) ->

  run: (replace, cb) ->
    str = @str
    for key, value of replace
      str = str.replace "{{ #{key} }}", value
    newName = @name.replace '.tpl.asm', ''
    fs.writeFileSync root + '/build-dir/' + newName + '.asm', str
    compileProgram newName, (err) ->
      return cb err if err
      runFromBin './' + newName, cb

exports.loadTemplate = (path) ->
  new Template path, fs.readFileSync root + '/src/' + path, encoding: 'utf8'

exports.itShould = (desc, cmd, returnText, returnCode=0) ->
  it 'should ' + desc, (done) ->
    runFromBin cmd, (ret) ->
      ret.should.deep.equal [returnCode, returnText]
      done()
