using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  grid = split(s)
  xmas = 0

  for i in 1:length(grid), j in 1:length(grid[1])
    xmas += countxmas(grid, (i, j))
  end

  "$xmas"
end

function countxmas(grid::Vector{SubString{String}}, (row, col)::Tuple{Int, Int})::Int32
  count = 0
  if grid[row][col] == 'X'
    for rowinc in -1:1, colinc in -1:1
      if (rowinc == -1 && row < 4) || (rowinc == 1 && row + 3 > length(grid)) ||
        (colinc == -1 && col < 4) || (colinc == 1 && col + 3 > length(grid[1])) ||
        (rowinc == 0 && colinc == 0)
      elseif grid[row + rowinc][col + colinc] == 'M' && grid[row + 2 * rowinc][col + 2 * colinc] == 'A' && grid[row + 3 * rowinc][col + 3 * colinc] == 'S'
        count += 1
      end
    end
  end
  count
end

function testPart1() 
  expected = read("./part1_test_output.txt", String);
  actual = part1("./test_input.txt");

  @test expected == actual
  println("Test for part 1 passed!")
end

function runPart1() 
  actual = part1("./input.txt");
  write("./part1_output.txt", actual)
end

function part2(file::AbstractString)::AbstractString
  s = read(file, String);

  grid = split(s)
  xmas = 0

  for i in 2:length(grid) - 1, j in 2:length(grid[1]) - 1
    xmas += countx_mas(grid, (i, j))
  end

  "$xmas"
end

function countx_mas(grid::Vector{SubString{String}}, (row, col)::Tuple{Int, Int})::Int32
  count = 0
  if grid[row][col] == 'A'
    diagupleft = (grid[row - 1][col - 1] == 'M' && grid[row + 1][col + 1] == 'S') || (grid[row - 1][col - 1] == 'S' && grid[row + 1][col + 1] == 'M')
    diagupright = (grid[row - 1][col + 1] == 'M' && grid[row + 1][col - 1] == 'S') || (grid[row - 1][col + 1] == 'S' && grid[row + 1][col - 1] == 'M')
    if diagupleft && diagupright
      count += 1
    end
  end
  count
end

function testPart2() 
  expected = read("./part2_test_output.txt", String);
  actual = part2("./test_input.txt");

  @test expected == actual
  println("Test for part 2 passed!")
end

function runPart2() 
  actual = part2("./input.txt");
  write("./part2_output.txt", actual)
end



runPart2()


