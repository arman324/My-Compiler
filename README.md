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
5. ``./my [testCaseName] [number from 0 to 3]`` for example to run the test case [4.in](https://github.com/arman324/My-Compiler/blob/master/Phase-02/4.in) ->  ``./my 4.in() 0``
> * To see other run options, you can see this [link](https://github.com/arman324/My-Compiler/blob/master/Phase-02/Program_Run_Options%20.pdf)
### Output:
This is the Abstract Syntax Tree (AST) of [4.in](https://github.com/arman324/My-Compiler/blob/master/Phase-02/4.in): 
<img width="1200" alt="Screen Shot 2020-08-07 at 1 43 12 PM" src="https://user-images.githubusercontent.com/35253872/89630112-1ff3b680-d8b4-11ea-920c-457625da6856.png">


## [Phase-03:]()
### Goal:

### How to Run:
1. ``bison Bison_Rule.y``
2. ``bison -d Bison_Rule.y -o myapp.cpp``
3. ``flex -o myapp_lex.cpp test.lex``
4. ``g++ -o my myapp.cpp myapp_lex.cpp``
5. ``./my [testCaseName]``
### Output:
This is the MIPS code of [testcase5_code.txt](https://github.com/arman324/My-Compiler/blob/master/Phase-03/testcase5_code.txt): 
<img width="600" alt="Screen Shot 2020-08-07 at 2 49 00 PM" src="https://user-images.githubusercontent.com/35253872/89636065-466a1f80-d8bd-11ea-95da-e7be04c57e49.png">


## Support
Reach out to me at riasiarman@yahoo.com
