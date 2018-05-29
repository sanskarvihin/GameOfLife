
Usage,
The whole screen is imagined as small squres size of 20, tapping on any point in screen will create an alive node in the region the tapped point belogns to. Tap it again to remove it. Press Run to proceed to next generation.

Approach,

    -  Any node has two states dead or alive
    -  Mantaining  list of alive nodes, and permentant dead nodes
    - Calculate all neighbour of an alive node , then retrive all neighbours of the retrived neighbour, This creates all interesting nodes, nodes that might change their status. Its called nodesToCheck list.
    - Apply rules of Game of Life, as per no of alive neighbour of an given node in nodesToCheck. Change their next state to as per rules.
    - Update View as per next status for every node inside nodesToCheck list

