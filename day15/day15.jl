using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  mapstr, movementsstr = split(s, "\n\n")

  ncols = findfirst(pos -> pos == '\n', mapstr) - 1
  nrows = Int((length(mapstr) + 1) / ncols) - 1
  boxes, walls = fill(false, (nrows, ncols)), fill(false, (nrows, ncols))
  bot = (-1, -1)

  for (i, row) in enumerate(split(mapstr))
    for (j, col) in enumerate(split(row, ""))
      if col == "O"
        boxes[i, j] = true
      elseif col == "#"
        walls[i, j] = true
      elseif col == "@"
        bot = (i, j)
      end
    end
  end

  directions = Dict("v" => (1, 0), "^" => (-1, 0), "<" => (0, -1), ">" => (0, 1))

  for movement in split(replace(movementsstr, "\n" => ""), "")
    dir = directions[movement]
    nextpos = (bot[1] + dir[1], bot[2] + dir[2])
    if !walls[nextpos[1], nextpos[2]]
      nextbox = nextpos
      while boxes[nextbox[1], nextbox[2]]
        nextbox = (nextbox[1] + dir[1], nextbox[2] + dir[2])
      end
      if !walls[nextbox[1], nextbox[2]] 
        if nextbox != nextpos
          boxes[nextpos[1], nextpos[2]] = false
          boxes[nextbox[1], nextbox[2]] = true
        end
        bot = nextpos
      end
    end
  end

  printMap(boxes * 3, walls, bot)

  gps = 0

  for row in 1:nrows, col in 1:ncols
    if boxes[row, col]
      gps += 100 * (row - 1) + (col - 1)
    end
  end

  "$gps"
end

function printMap(boxes::Matrix{Int}, walls::Matrix{Bool}, bot::Tuple{Int, Int})
  for row in 1:size(boxes)[1]
    for col in 1:size(boxes)[2]
      if boxes[row, col] == 1
        print("[")
      elseif boxes[row, col] == 2
        print("]")
      elseif boxes[row, col] == 3
        print("O")
      elseif walls[row, col]
        print("#")
      elseif (row, col) == bot
        print("@")
      else
        print(".")
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

  mapstr, movementsstr = split(s, "\n\n")

  ncols = findfirst(pos -> pos == '\n', mapstr) - 1
  nrows = Int((length(mapstr) + 1) / ncols) - 1
  ncols *= 2
  boxes, walls = fill(0, (nrows, ncols)), fill(false, (nrows, ncols))
  bot = (-1, -1)

  for (i, row) in enumerate(split(mapstr))
    for (j, col) in enumerate(split(row, ""))
      if col == "O"
        boxes[i, j * 2 - 1] = 1
        boxes[i, j * 2] = 2
      elseif col == "#"
        walls[i, j * 2 - 1] = true
        walls[i, j * 2] = true
      elseif col == "@"
        bot = (i, j * 2 - 1)
      end
    end
  end

  directions = Dict("v" => (1, 0), "^" => (-1, 0), "<" => (0, -1), ">" => (0, 1))

  for movement in split(replace(movementsstr, "\n" => ""), "")
    dir = directions[movement]
    nextpos = (bot[1] + dir[1], bot[2] + dir[2])
    if !walls[nextpos[1], nextpos[2]]
      if dir[1] == 0
        # horizontal
        nextbox = nextpos[2]
        while boxes[bot[1], nextbox] > 0
          nextbox = nextbox + dir[2]
        end
        if !walls[nextpos[1], nextbox] 
          if nextbox != nextpos[2]
            currside = sign(dir[2] + 1) + 1
            for col in min(nextbox, nextpos[2]):max(nextbox, nextpos[2])
              boxes[nextpos[1], col] = 2 - currside
              currside = (currside + 1) % 2
            end
            boxes[nextpos[1], nextpos[2]] = 0
          end
          bot = nextpos
        end
      else
        # vertical
        endrow = nextpos[1]
        boxcols = [Set{Tuple{Int, Int}}()]
        wall = false
        if boxes[nextpos[1], nextpos[2]] == 1
          push!(boxcols[1], nextpos)
          push!(boxcols[1], (nextpos[1], nextpos[2] + 1))
        elseif boxes[nextpos[1], nextpos[2]] == 2
          push!(boxcols[1], nextpos)
          push!(boxcols[1], (nextpos[1], nextpos[2] - 1))
        elseif walls[nextpos[1], nextpos[2]]
          wall = true
        end
        while !wall && length(boxcols[end]) > 0
          endrow += dir[1]
          nextrow = Set{Tuple{Int, Int}}()
          for box in boxcols[end]
            if boxes[endrow, box[2]] == 1
              push!(nextrow, (endrow, box[2]))
              push!(nextrow, (endrow, box[2] + 1))
            elseif boxes[endrow, box[2]] == 2
              push!(nextrow, (endrow, box[2]))
              push!(nextrow, (endrow, box[2] - 1))
            elseif walls[endrow, box[2]]
              wall = true
              break
            end
          end
          push!(boxcols, nextrow)
        end
        if !wall
          for row in reverse(boxcols)
            for box in row
              boxes[box[1] + dir[1], box[2]] = boxes[box[1], box[2]]
              boxes[box[1], box[2]] = 0
            end
          end
          bot = nextpos
        end
      end
    end
  end

  printMap(boxes, walls, bot)

  gps = 0

  for row in 1:nrows, col in 1:ncols
    if boxes[row, col] == 1
      gps += 100 * (row - 1) + (col - 1)
    end
  end

  "$gps"
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


