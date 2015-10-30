{loadTemplate} = require './tools'

describe '_u64_to_str', ->
  template = loadTemplate '_u64_to_str_test.tpl.asm'
  numbersToTest = [0, 1, 7, 13, 432, 12345, 123456, '18446744073709551615']
  for n in numbersToTest
    do (n) ->
      it 'should show ' + n, (done) ->
        template.run {number: '' + n}, (ret) ->
          ret.should.deep.equal [0, '' + n]
          done()
