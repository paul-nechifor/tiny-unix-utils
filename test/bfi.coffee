plus65 = ('+' for _ in [1 .. 65]).join ''
hello = '++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+' +
    '++.>>.<-.<.+++.------.--------.>>+.>++.'
itShould 'prints capital A', "./bfi #{plus65}.", 'A'
itShould 'prints capital ABC', "./bfi #{plus65}.+.+.", 'ABC'
