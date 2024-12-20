using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  picos, track = split(s, "\n\n")
  picos = parse(Int, picos)

  ncols = findfirst(pos -> pos == '\n', track) - 1
  nrows = Int((length(track) + 1) / ncols) - 1

  walls = fill(false, (nrows, ncols))
  start = (-1, -1)
  exit = (-1, -1)

  for (i, row) in enumerate(split(track))
    for (j, col) in enumerate(row)
      walls[i, j] = col == '#'
      if col == 'S'
        start = (i, j)
      elseif col == 'E'
        exit = (i, j)
      end
    end
  end

  distances = fill(Inf, (nrows, ncols))
  distances[start...] = 0
  curr = start
  offsets = [(0, -1), (0, 1), (1, 0), (-1, 0)]
  trackseq = []
  while curr != exit
    push!(trackseq, curr)
    neighbors = [(curr[1] + off[1], curr[2] + off[2]) for off in offsets]
    next = filter(n -> !walls[n...] && distances[n...] == Inf, neighbors)[1]
    distances[next...] = distances[curr...] + 1
    curr = next
  end

  cheats = 0
  for curr in trackseq
    neighbors = Set([(curr[1] + off1[1] + off2[1], curr[2] + off1[2] + off2[2]) for off1 in offsets, off2 in offsets])
    neighbors = filter(n -> 1 <= n[1] <= nrows && 1 <= n[2] <= ncols && !walls[n...], neighbors)
    cheats += sum([distances[n...] - distances[curr...] > picos for n in neighbors])
  end

  "$cheats"
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

  picos, track = split(s, "\n\n")
  picos = parse(Int, picos)

  ncols = findfirst(pos -> pos == '\n', track) - 1
  nrows = Int((length(track) + 1) / ncols) - 1

  walls = fill(false, (nrows, ncols))
  start = (-1, -1)
  exit = (-1, -1)

  for (i, row) in enumerate(split(track))
    for (j, col) in enumerate(row)
      walls[i, j] = col == '#'
      if col == 'S'
        start = (i, j)
      elseif col == 'E'
        exit = (i, j)
      end
    end
  end

  distances = fill(Inf, (nrows, ncols))
  distances[start...] = 0
  curr = start
  offsets = [(0, -1), (0, 1), (1, 0), (-1, 0)]
  trackseq = []
  while curr != exit
    push!(trackseq, curr)
    neighbors = [(curr[1] + off[1], curr[2] + off[2]) for off in offsets]
    next = filter(n -> !walls[n...] && distances[n...] == Inf, neighbors)[1]
    distances[next...] = distances[curr...] + 1
    curr = next
  end

  cheats = 0
  push!(offsets, (0, 0))
  phaselocs = Set([(0, 0)])
  for _ in 1:20
    union!(phaselocs, [(p[1] + o[1], p[2] + o[2]) for p in phaselocs, o in offsets])
  end

  for curr in trackseq
    neighbors = [(curr[1] + off[1], curr[2] + off[2]) for off in phaselocs]
    neighbors = filter(n -> 1 <= n[1] <= nrows && 1 <= n[2] <= ncols && !walls[n...], neighbors)
    cheats += sum([distances[n...] - distances[curr...] >= (picos + abs(n[1] - curr[1]) + abs(n[2] - curr[2])) for n in neighbors])
  end

  "$cheats"
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


