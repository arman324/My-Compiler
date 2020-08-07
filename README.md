# A simple compiler for a language similar to C++
## Overview

## Requirements
* Requires ``flex 2.5.35`` or later.
* Requires ``Bison 2.3`` or later.

## [Phase-01:](https://github.com/arman324/My-Compiler/tree/master/Phase-01)
### Goal:

### How to Run:

### Output:


## [Phase-02:](https://github.com/arman324/My-Compiler/tree/master/Phase-02)
### Goal:

### How to Run:
1. ``bison Bison_Rule.y``
2. ``bison -d Bison_Rule.y -o myapp.cpp``
3. ``flex -o myapp_lex.cpp test.lex``
4. ``g++ -o my myapp.cpp myapp_lex.cpp``
5. ``./my [testCaseName] [number from 0 to 4]`` for example to run the test case [4.in](https://github.com/arman324/My-Compiler/blob/master/Phase-02/4.in) ->  ``./my 4.in() 0``
### Output:


## [Phase-03:]()
### Goal:

### How to Run:
1. ``bison Bison_Rule.y``
2. ``bison -d Bison_Rule.y -o myapp.cpp``
3. ``flex -o myapp_lex.cpp test.lex``
4. ``g++ -o my myapp.cpp myapp_lex.cpp``
5. ``./my [testCaseName]``
### Output:


## Support
Reach out to me at riasiarman@yahoo.com
