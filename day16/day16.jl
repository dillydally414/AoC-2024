using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  ncols = findfirst(pos -> pos == '\n', s) - 1
  nrows = Int((length(s) + 1) / ncols) - 1
  walls = fill(false, (nrows, ncols))
  start = (-1, -1)
  finish = (-1, -1)

  for (i, row) in enumerate(split(s))
    for (j, col) in enumerate(split(row, ""))
      if col == "#"
        walls[i, j] = true
      elseif col == "S"
        start = (i, j)
      elseif col == "E"
        finish = (i, j)
      end
    end
  end

  distances = fill(Inf, (nrows, ncols))
  distances[start[1], start[2]] = 0
  queue = [((0, 1), start)]
  while length(queue) > 0 && distances[finish[1], finish[2]] == Inf
    _, nextidx = findmin(q -> distances[q[2][1], q[2][2]], queue)
    currdir, currpos = popat!(queue, nextidx)
    currdist = distances[currpos[1], currpos[2]]
    straight = (currpos[1] + currdir[1], currpos[2] + currdir[2])
    if !walls[straight[1], straight[2]] && currdist + 1 < distances[straight[1], straight[2]]
      push!(queue, (currdir, straight))
      distances[straight[1], straight[2]] = currdist + 1
    end
    leftdir = (-currdir[2], currdir[1])
    leftturn = (currpos[1] + leftdir[1], currpos[2] + leftdir[2])
    if !walls[leftturn[1], leftturn[2]] && currdist + 1001 < distances[leftturn[1], leftturn[2]]
      push!(queue, (leftdir, leftturn))
      distances[leftturn[1], leftturn[2]] = currdist + 1001
    end
    rightdir = (currdir[2], -currdir[1])
    rightturn = (currpos[1] + rightdir[1], currpos[2] + rightdir[2])
    if !walls[rightturn[1], rightturn[2]] && currdist + 1001 < distances[rightturn[1], rightturn[2]]
      push!(queue, (rightdir, rightturn))
      distances[rightturn[1], rightturn[2]] = currdist + 1001
    end
  end

  printMap(distances, walls)

  "$(Int(distances[finish[1], finish[2]]))"
end

function printMap(distances::Matrix{Float64}, walls::Matrix{Bool})
  for i in 1:size(distances)[1]
    for j in 1:size(distances)[2]
      if distances[i, j] == Inf
        if walls[i, j]
          print('#')
        else
          print('.')
        end
      else
        print('A' + (floor(Int, distances[i, j] / 1000) % 58))
      end
    end
    println()
  end
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

  ncols = findfirst(pos -> pos == '\n', s) - 1
  nrows = Int((length(s) + 1) / ncols) - 1
  walls = fill(false, (nrows, ncols))
  start = (-1, -1)
  finish = (-1, -1)

  for (i, row) in enumerate(split(s))
    for (j, col) in enumerate(split(row, ""))
      if col == "#"
        walls[i, j] = true
      elseif col == "S"
        start = (i, j)
      elseif col == "E"
        finish = (i, j)
      end
    end
  end

  distances = fill(Inf, (nrows, ncols))
  distances[start[1], start[2]] = 0
  queue = [((0, 1), start)]
  while length(queue) > 0 && distances[finish[1], finish[2]] == Inf
    _, nextidx = findmin(q -> distances[q[2][1], q[2][2]], queue)
    currdir, currpos = popat!(queue, nextidx)
    currdist = distances[currpos[1], currpos[2]]
    straight = (currpos[1] + currdir[1], currpos[2] + currdir[2])
    if !walls[straight[1], straight[2]] && currdist + 1 < distances[straight[1], straight[2]]
      push!(queue, (currdir, straight))
      distances[straight[1], straight[2]] = currdist + 1
    end
    leftdir = (-currdir[2], currdir[1])
    leftturn = (currpos[1] + leftdir[1], currpos[2] + leftdir[2])
    if !walls[leftturn[1], leftturn[2]] && currdist + 1001 < distances[leftturn[1], leftturn[2]]
      push!(queue, (leftdir, leftturn))
      distances[leftturn[1], leftturn[2]] = currdist + 1001
    end
    rightdir = (currdir[2], -currdir[1])
    rightturn = (currpos[1] + rightdir[1], currpos[2] + rightdir[2])
    if !walls[rightturn[1], rightturn[2]] && currdist + 1001 < distances[rightturn[1], rightturn[2]]
      push!(queue, (rightdir, rightturn))
      distances[rightturn[1], rightturn[2]] = currdist + 1001
    end
  end

  pathdist = fill(Inf, (nrows, ncols))
  onpath = Set{Tuple{Int, Int}}([start, finish])
  traceback = Set{Tuple{Int, Int}}([finish])
  offsets = [(0, -1), (0, 1), (1, 0), (-1, 0)]
  while length(traceback) > 0
    curr = pop!(traceback)
    pathdist[curr[1], curr[2]] = 14000
    currdist = distances[curr[1], curr[2]]
    neighbors = [(curr[1] + offset[1], curr[2] + offset[2]) 
                  for offset in offsets if (
                    distances[curr[1] + offset[1], curr[2] + offset[2]] in [currdist - 1, currdist - 1001] || 
                    (distances[curr[1] + offset[1], curr[2] + offset[2]] == distances[curr[1] - offset[1], curr[2] - offset[2]] - 2 &&
                    (curr[1] - offset[1], curr[2] - offset[2]) in onpath)
                  )]
    union!(traceback, neighbors)
    union!(onpath, neighbors)
  end

  printMap(distances + pathdist .- 14000, walls)
  println()
  printMap(pathdist, walls)

  "$(length(onpath))"
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


