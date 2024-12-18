using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  setup, bytes = split(s, "\n\n")
  dims, nbytes = (parse(Int, n) for n in split(setup))
  bytes = [Tuple(parse(Int, n) + 1 for n in split(row, ",")) for row in split(bytes)]

  corrupted = fill(false, (dims, dims))
  for b in bytes[1:nbytes]
    corrupted[b...] = true
  end

  path = minPath(corrupted)

  "$(Int(path))"
end

function minPath(walls::Matrix{Bool})::Float64
  dims = size(walls)[1]
  start = (1, 1)
  exit = (dims, dims)
  distances = fill(Inf, (dims, dims))
  distances[start...] = 0
  queue = [start]

  offsets = [(0, 1), (1, 0), (-1, 0), (0, -1)]
  while length(queue) > 0
    curr = pop!(queue)
    currdist = distances[curr...]
    for neighbor in [(curr[1] + off[1], curr[2] + off[2]) for off in offsets]
      if 1 <= neighbor[1] <= dims && 1 <= neighbor[2] <= dims && !walls[neighbor...] && currdist + 1 < distances[neighbor...]
        distances[neighbor...] = currdist + 1
        push!(queue, neighbor)
      end
    end
  end

  distances[exit...]
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

  setup, bytes = split(s, "\n\n")
  dims, nbytes = (parse(Int, n) for n in split(setup))
  bytes = [Tuple(parse(Int, n) + 1 for n in split(row, ",")) for row in split(bytes)]

  corrupted = fill(false, (dims, dims))
  for b in bytes[1:nbytes]
    corrupted[b...] = true
  end

  for b in bytes[nbytes + 1:end]
    corrupted[b...] = true
    path = minPath(corrupted)
    if path == Inf
      return "$(b[1] - 1),$(b[2] - 1)"
    end
  end

  "No blocking byte"
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


