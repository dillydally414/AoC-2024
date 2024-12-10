using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  trailheads = Set{Tuple{Int32,Int32}}()
  trails = Dict{Tuple{Int32,Int32}, Vector{Tuple{Int32,Int32}}}()

  grid = [[parse(Int32, c) for c in split(line, "")] for line in split(s)]
  numrows, numcols = length(grid), length(grid[1])

  for row in 1:numrows, col in 1:numcols
    altitude = grid[row][col]
    neighbors = filter(pos -> 1 <= pos[1] <= numrows && 
      1 <= pos[2] <= numcols && grid[pos[1]][pos[2]] == altitude + 1, 
      [(row + 1, col), (row - 1, col), (row, col + 1), (row, col - 1)])
    trails[(row, col)] = neighbors
    if altitude == 0
      push!(trailheads, (row, col))
    end
  end

  scores = 0

  for head in trailheads
    locations = [head]
    for _altitude in 1:9
      locations = union([trails[loc] for loc in locations]...)
    end
    scores += length(locations)
  end

  "$scores"
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

  trailheads = Set{Tuple{Int32,Int32}}()
  trails = Dict{Tuple{Int32,Int32}, Vector{Tuple{Int32,Int32}}}()

  grid = [[parse(Int32, c) for c in split(line, "")] for line in split(s)]
  numrows, numcols = length(grid), length(grid[1])

  for row in 1:numrows, col in 1:numcols
    altitude = grid[row][col]
    neighbors = filter(pos -> 1 <= pos[1] <= numrows && 
      1 <= pos[2] <= numcols && grid[pos[1]][pos[2]] == altitude + 1, 
      [(row + 1, col), (row - 1, col), (row, col + 1), (row, col - 1)])
    trails[(row, col)] = neighbors
    if altitude == 0
      push!(trailheads, (row, col))
    end
  end

  ratings = 0

  for head in trailheads
    locations = [head]
    for _altitude in 1:9
      locations = vcat([trails[loc] for loc in locations]...)
    end
    ratings += length(locations)
  end

  "$ratings"
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


