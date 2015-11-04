itShould 'work with no arguments', './echo', ''
itShould 'work with a single char', './echo a', 'a'
itShould 'work with two single char args', './echo a b', 'a b'
itShould 'work with three single char args', './echo a b c', 'a b c'
