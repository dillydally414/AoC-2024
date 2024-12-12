using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  plots = Dict{Tuple{Int,Int}, Vector{Tuple{Int,Int}}}()

  grid = [[c for c in split(line, "")] for line in split(s)]
  numrows, numcols = length(grid), length(grid[1])

  for row in 1:numrows, col in 1:numcols
    plant = grid[row][col]
    neighbors = filter(pos -> 1 <= pos[1] <= numrows && 
      1 <= pos[2] <= numcols && grid[pos[1]][pos[2]] == plant, 
      [(row + 1, col), (row - 1, col), (row, col + 1), (row, col - 1)])
    plots[(row, col)] = neighbors
  end

  regions = []
  loc_to_region = Dict{Tuple{Int, Int}, Int}()

  for row in 1:numrows, col in 1:numcols
    visited = Set{Tuple{Int, Int}}()
    queue = [(row, col)]
    while length(queue) > 0
      next = popfirst!(queue)
      if next in visited
        continue
      end
      push!(visited, next)
      if haskey(loc_to_region, next)
        loc_to_region[(row, col)] = loc_to_region[next]
        break
      end
      append!(queue, plots[next])
    end
    if !haskey(loc_to_region, (row, col))
      push!(regions, visited)
      loc_to_region[(row, col)] = length(regions)
    end
  end

  ct = 0

  for region in regions
    area = length(region)
    perimeter = sum([4 - length(plots[pos]) for pos in region])
    ct += area * perimeter
  end

  "$ct"
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

  plots = Dict{Tuple{Int,Int}, Vector{Tuple{Int,Int}}}()

  grid = [[c for c in split(line, "")] for line in split(s)]
  numrows, numcols = length(grid), length(grid[1])

  for row in 1:numrows, col in 1:numcols
    plant = grid[row][col]
    neighbors = filter(pos -> 1 <= pos[1] <= numrows && 
      1 <= pos[2] <= numcols && grid[pos[1]][pos[2]] == plant, 
      [(row + 1, col), (row - 1, col), (row, col + 1), (row, col - 1)])
    plots[(row, col)] = neighbors
  end

  regions = []
  loc_to_region = Dict{Tuple{Int, Int}, Int}()

  for row in 1:numrows, col in 1:numcols
    visited = Set{Tuple{Int, Int}}()
    queue = [(row, col)]
    while length(queue) > 0
      next = popfirst!(queue)
      if next in visited
        continue
      end
      push!(visited, next)
      if haskey(loc_to_region, next)
        loc_to_region[(row, col)] = loc_to_region[next]
        break
      end
      append!(queue, plots[next])
    end
    if !haskey(loc_to_region, (row, col))
      push!(regions, visited)
      loc_to_region[(row, col)] = length(regions)
    end
  end

  ct = 0

  for region in regions
    area = length(region)
    up = Set{Tuple{Int, Int}}(filter(pos -> !((pos[1] - 1, pos[2]) in region), region))
    down = Set{Tuple{Int, Int}}(filter(pos -> !((pos[1] + 1, pos[2]) in region), region))
    left = Set{Tuple{Int, Int}}(filter(pos -> !((pos[1], pos[2] - 1) in region), region))
    right = Set{Tuple{Int, Int}}(filter(pos -> !((pos[1], pos[2] + 1) in region), region))
    sides = 0
    for horizon in [up, down]
      while length(horizon) > 0
        queue = [pop!(horizon)]
        while length(queue) > 0
          next = pop!(queue)
          delete!(horizon, next)
          append!(queue, 
            filter(p -> p in horizon, 
              [(next[1], next[2] + 1), (next[1], next[2] - 1)]))
        end
        sides += 1
      end
    end
    for vert in [left, right]
      while length(vert) > 0
        queue = [pop!(vert)]
        while length(queue) > 0
          next = pop!(queue)
          delete!(vert, next)
          append!(queue, 
            filter(p -> p in vert, 
              [(next[1] + 1, next[2]), (next[1] - 1, next[2])]))
        end
        sides += 1
      end
    end
    ct += area * sides
  end

  "$ct"
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



testPart2()


