{itShould, describeProgram} = require './tools'

describeProgram 'false', ->
  itShould 'return 1', './false', '', 1
