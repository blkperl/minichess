Homework 1
----------

I chose to use ruby for my minichess bot because I've never done a large assignment in a dynamic language before. I used a 2D array for my board and implemented a Move, Square, and State class. If I have extra time later I might make each piece its own class.

I have finished randomMove and my bot can play against itself. However, there seems to be a rare bug where it tries an invalid move. I ran the below bash for loop to make it play itself 1000 times and discovered the problem on game 112.

for i in `seq 10000` ; do echo game $i; ruby game.rb >> /tmp/minichess.log;  done

I still need to implement humanMove and reading in a board before moving on to Homework 2.

See README.md for instructions on how to run it.


