{ /* Specify dependency instead in the comand line  */
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
          (op:[+-] product:product  /* init, update, and return */
            &{ stack.push(op, product); return stack.make(action); })* 
             { return stack.pop(); } 
product = first:value &{ return stack.push(first); } 
          (op:[*/] value:value 
            &{ stack.push(op, value); return stack.make(action); })* 
             { return stack.pop(); } 
value   = number:$[0-9]+                     { return parseInt(number,10); }
        / '(' sum:sum ')'                    { return sum; }


