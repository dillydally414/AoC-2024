using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  guardpos = (-1, -1) # row, col
  walls = []

  for (row, line) in enumerate(split(s))
    if contains(line, '^')
      guardpos = (row, findfirst(c -> c == '^', line))
    end
    push!(walls, [c == '#' for c in line])
  end

  visited = [[false for _ in row] for row in walls]
  guarddir = (-1, 0)  # row, col

  while 1 <= guardpos[1] <= length(walls) && 
    1 <= guardpos[2] <= length(walls[1])
    visited[guardpos[1]][guardpos[2]] = true
    next = (guardpos[1] + guarddir[1], guardpos[2] + guarddir[2])
    if 1 <= next[1] <= length(walls) && 
      1 <= next[2] <= length(walls[1]) && 
      walls[next[1]][next[2]]
      guarddir = (guarddir[2], -guarddir[1])
    else
      guardpos = next
    end
  end

  count = sum(sum(visited))

  "$count"
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

  guardpos = (-1, -1) # row, col
  walls = []

  for (row, line) in enumerate(split(s))
    if contains(line, '^')
      guardpos = (row, findfirst(c -> c == '^', line))
    end
    push!(walls, [c == '#' for c in line])
  end

  visited = [[[] for _ in row] for row in walls]
  guarddir = (-1, 0)  # row, col
  obstructions = [[false for _ in row] for row in walls]

  while 1 < guardpos[1] < length(walls) && 
    1 < guardpos[2] < length(walls[1])
    push!(visited[guardpos[1]][guardpos[2]], guarddir)
    next = (guardpos[1] + guarddir[1], guardpos[2] + guarddir[2])
    if 1 <= next[1] <= length(walls) && 
      1 <= next[2] <= length(walls[1]) && 
      walls[next[1]][next[2]]
      guarddir = (guarddir[2], -guarddir[1])
    else
      obstrdir = (guarddir[2], -guarddir[1])
      obstrpos = guardpos
      visitedcpy = deepcopy(visited)
      # needs to be the first time we're about to visit the next spot, otherwise obstruction would have already altered the path
      if length(visited[next[1]][next[2]]) == 0
        while 1 < obstrpos[1] < length(walls) && 
          1 < obstrpos[2] < length(walls[1]) 
          push!(visitedcpy[obstrpos[1]][obstrpos[2]], obstrdir)
          nextobstr = (obstrpos[1] + obstrdir[1], obstrpos[2] + obstrdir[2])
          if 1 <= nextobstr[1] <= length(walls) && 
            1 <= nextobstr[2] <= length(walls[1]) && 
            (walls[nextobstr[1]][nextobstr[2]] || nextobstr == next) # need to remember to also rotate if hitting same wall in future
            obstrdir = (obstrdir[2], -obstrdir[1])
          else
            obstrpos = nextobstr
          end
          if obstrdir in visitedcpy[obstrpos[1]][obstrpos[2]]
            obstructions[next[1]][next[2]] = true
            break
          end
        end
      end
      guardpos = next
    end
  end

  count = sum(sum(obstructions))

  "$count"
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


