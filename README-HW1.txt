Homework 1
----------

My bot can currently play against itself randomely. There seems to be a once in a while bug where it tries an invalid move. I ran the below bash for loop to make it play itself 1000 times and discovered the problem on game 112.

for i in `seq 10000` ; do echo game $i; ruby game.rb >> /tmp/minichess.log;  done

TODO:
 * Impment human_move
