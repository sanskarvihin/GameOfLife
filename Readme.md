
Intro:
The Game of Life is a two dimensional board game where interesting patterns evolve through the time. Its one of the best example of how few simple rules can result into incredibly complex behaviour. I think, its cool and gorgeous to watch.

A square in Grid either alive or dead.The behaviour of each cell depends on the state of its eight immediate neighbour.

Rules:

For Live cells,
1. a Live cell with Zero or one neighbours will die.
2. a live cell with two or three live neighbours will remain alive.
3. a live cell wiht four or more live neighbours will die.

For Dead cells,
1. a dead cell with exactly three live neighbours becomes alive.
2. in all other cases a dead cell will stay dead.

Usage,
The whole screen is imagined as small squres size of 20, tapping on any point in screen will create an alive node in the region the tapped point belogns to. Tap it again to remove it. Press Run to proceed to next generation.

Approach,

    -  Any node has two states dead or alive
    -  Mantaining  list of alive nodes, and permentant dead nodes
    - Calculate all neighbour of an alive node , then retrive all neighbours of the retrived neighbour, This creates all interesting nodes, nodes that might change their status. Its called nodesToCheck list.
    - Apply rules of Game of Life, as per no of alive neighbour of an given node in nodesToCheck. Change their next state to as per rules.
    - Update View as per next status for every node inside nodesToCheck list


<img src="https://github.com/sanskarvihin/GameOfLife/blob/master/demo.gif" width="320" height="580" />

