{itShould, describeProgram} = require './tools'

describeProgram 'cat', ->
  x10000 = ('x' for x in [1 .. 10000]).join ''
  itShould 'work with a single character', 'echo -n a | ./cat', 'a'
  itShould 'work with a new line', 'echo word1 word2 | ./cat', 'word1 word2\n'
  itShould 'work with large files', "echo -n #{x10000} | ./cat", x10000
