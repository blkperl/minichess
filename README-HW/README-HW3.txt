Homework 3
----------

I implemented ordered alphaBeta pruning but unfortunately its 
still making some bad decisions. In addition, I've added 
lots more spec tests for many of my methods. So far it has helped
me find several bugs in my endOfGame method.

At this point I have improved my evaluator to skip negamax if the move
is to capture a king piece along with some work to encourage pawn movement.
I've added additional points for moving pawns forward and more points for
covering the diagonals.

As a result of ordered alphabeta my bot now reaches depth 7 for some moves and does not work through as many nodes.

Left to implement:
    - do-undo
    - additional improvements to move evaluator
