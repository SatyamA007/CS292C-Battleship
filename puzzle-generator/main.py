import puzzle

puzzle_params = [
    [15, 1,	1,	2,	3],
    [15, 1,	2,	2,	4],
    [15, 1,	2,	3,	4],
    [15, 2,	2,	4,	4],
    [15, 2,	2,	4,	6],
    [15, 2,	3,	4,	5],
    [15, 3,	2,	4,	6],
    [15, 3,	3,	5,	6]
    ]

for pzz in puzzle_params:
    x = puzzle.Puzzle(pzz[0],pzz[0],pzz[1],pzz[2],pzz[3],pzz[4],0)
    x.print_solution_to_file_rosette()