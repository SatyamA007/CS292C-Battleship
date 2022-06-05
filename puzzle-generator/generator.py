import puzzle

puzzle_params = [
    [14 ,2,	3,	4,	5],
    [15, 1,	2,	3,	4]
    ]

for pzz in puzzle_params:
    x = puzzle.Puzzle(pzz[0],pzz[0],pzz[1],pzz[2],pzz[3],pzz[4],0)
    x.print_solution_to_file_rosette()