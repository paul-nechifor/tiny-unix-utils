{itShould, describeProgram} = require './tools'

describeProgram 'true', ->
  itShould 'return 0', './true', '', 0
