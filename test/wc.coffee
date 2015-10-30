{itShould, describeProgram} = require './tools'

describeProgram 'wc', ->
  x12345 = ('x' for x in [1 .. 12345]).join ''
  itShould 'work with no characters', 'echo -n | ./wc', '0 0 0\n'
  itShould 'work with a single character', 'echo -n a | ./wc', '1 1 0\n'
  itShould 'work with a single word', 'echo hello | ./wc', '6 3 1\n'
  itShould 'work with a larger file', "echo -n #{x12345} | ./wc", '12345 6 0\n'
