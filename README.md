## Battleship Solitaire

Battleship is a find-the-fleet puzzle based on a grid representing an ocean section with a fleet of ships hidden inside. The goal is to reveal the fleet by logically deducing the location of the ship segment. Such puzzles often appear in puzzle magazines.

Please give the game a try. It can be played online at [gamesforthebrain](https://www.gamesforthebrain.com/game/shipfind/)


## The problem

To solve this, various clues and restrictions are given. We define them as rules for our puzzle:

> **Rule 1:** the numbers on the right and on the bottom of the grid indicate how many squares in the corresponding row and column are occupied by ship segments. The fleet traditionally consists of 10 ships. One battleship, four spaces long, two cruisers three spaces long, three destroyers two spaces long, and four submarines that take only one space.

> **Rule 2:** Ships may be oriented horizontally or vertically without touching each other, not even diagonally. 

And sometimes, 

> **Rule 3:** A few squares may be revealed to start you off. Revealed squares are fixed and the solution must incorporate these squares as is.


## Our Rosette-Aided Solution

1.  **Generate puzzles:** We develop an algorithm that, given the input parameters for the puzzle, will randomly place all the ships in the grid of size m _**x**_ n such that: it stays within the grid boundary and doesn’t overlap with any ship already placed. The total area of the grid is an effective metric for puzzle difficulty since  
    it proportionally increases the number of variables considered.
2.  **Define the constraints:** M.Smith et al. discuss a basic model for tackling the puzzle by developing a Constraint Programming (CP) model for it. We take a  
    note of the necessary constraints expressed by  M.Smith et al., that we adapt to build our model assertions 
3.  **Design the solver:** We maintain each square of the puzzle and ship as a symbolic variable. A binding of symbolic constants to concrete values exists if all the assumptions and assertions are satisfiable. 
4.  **Parse the constraints:** Interface the solver to different difficulty-based puzzles and precisely parse the constraints from the generated puzzles
5.  **Synthesis:** Using Rosette’s Angelic Execution, search for a binding of symbolic constants to concrete values that satisfies all the assumptions and assertions  
    encountered during and before the call to “solve” query


## Result

The average time taken to solve various difficulty level puzzles is given below:

| Difficulty | N range for Grid Size  of NxN | Average Time (in s) |
| --- | --- | --- |
| Easy | \<10 | 8.04 |
| Medium | 10-13 | 44.41 |
| Hard | \>13 | 517.59 |

The specs of the machine running are - Windows 10 PC (Ryzen 7 3750h, 16GB RAM, 1660ti) / **ASUS ROG** Zephyrus **G** 2019