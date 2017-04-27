# pegjs-strip [![npm version](https://badge.fury.io/js/pegjs-strip.svg)](https://badge.fury.io/js/pegjs-strip)

<img src="https://nodei.co/npm/pegjs-strip.png?downloads=true&stars=true" alt=""/>

pegjs-strip is a utility for removing Javascript code fragments from the specified PEG.js grammar file.

The utility removes all code-related statements such as the initializer block, actions and labels. The semantic predicate `&{<code>}` and `!{<code>}` are replaced with `&{return true;}` or `!{return false;}` respectively. 

By default, the utility does not strip comment blocks. To remove comments, `--strip-comment` option can be used.

## Usage

```
Usage: pegjs-strip [options] file


Options:
  -h, --help                     show this help.
      --strip-comment            Strip comments.
      --keep-initializer         Keep the initializer block.
      --keep-action              Keep actions.
      --keep-label               Keep labels.
      --keep-semantic-predicate  Keep semantic predicates.
      --clean-semantic           Clean semantic predicates.
```

## Example

The following grammar is taken from [this set of examples](https://github.com/ULL-ESIT-PL-1617/pegjs-examples):

```
{ // Specify dependency instead in the comand line 
  // option -d PEGStack:@ull-esit-pl/peg-stack (see Rakefile)
  // var PEGStack = require('@ull-esit-pl/peg-stack');
  var stack = new PEGStack();
  var action = function() {
    var [val1, op, val2] = stack.pop(3);
    stack.log('Action!: '+`${val1} ${op} ${val2}`); 
    stack.push(eval(`${val1} ${op} ${val2}`)); 
  }
}

sum     = first:product &{ return stack.push(first); } 
          (op:[+-] product:product 
            &{ stack.push(op, product); return stack.make(action); })* 
             { return stack.pop(); } 
product = first:value &{ return stack.push(first); } 
          (op:[*/] value:value 
            &{ stack.push(op, value); return stack.make(action); })* 
             { return stack.pop(); } 
value   = number:$[0-9]+                     { return parseInt(number,10); }
        / '(' sum:sum ')'                    { return sum; }
```

To remove all the code in the grammar, just run the utility with the grammar file as the first argument. 
The result is then written to the standard output as follows.

```
$ pegjs-strip --clean-semantic removeleftrecursionwithintermidateactions2.pegjs


sum     = product
          ([+-] product
            )*

product = value
          ([*/] value
            )*

value   = $[0-9]+
        / '(' sum ')'
```




