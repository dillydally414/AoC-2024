using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  openings = []
  counts = []
  block = true
  curr = 1
  tot_blocks = 0

  for c in s
    ct = parse(Int8, c)
    if block
      tot_blocks += ct
      push!(counts, curr:curr + ct - 1)
    elseif ct > 0
      append!(openings, curr:curr + ct - 1)
    end
    curr += ct
    block = !block
  end

  filter!(pos -> pos <= tot_blocks, openings)

  moving = length(counts)

  while length(openings) > 0
    prevpos = counts[moving]
    while all(pos -> pos <= tot_blocks, prevpos)
      moving -= 1
      prevpos = counts[moving]
    end
    next = popfirst!(openings)
    counts[moving] = vcat(next, prevpos[1:end - 1])
  end

  checksum = sum([sum([pos - 1 for pos in positions]) * (id - 1) 
  for (id, positions) in enumerate(counts)])
  
  "$checksum"
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

  openings = []
  counts = []
  block = true
  curr = 1
  tot_blocks = 0

  for c in s
    ct = parse(Int8, c)
    if block
      tot_blocks += ct
      push!(counts, curr:curr + ct - 1)
    elseif ct > 0
      push!(openings, curr:curr + ct - 1)
    end
    curr += ct
    block = !block
  end

  for block_idx in length(counts):-1:1
    block = counts[block_idx]
    for (o_idx, opening) in enumerate(openings)
      if length(block) <= length(opening) && first(opening) <= first(block)
        counts[block_idx] = opening[1:length(block)]
        openings[o_idx] = opening[length(block) + 1:end]
        break
      end
    end
  end

  checksum = sum([sum([pos - 1 for pos in positions]) * (id - 1) 
  for (id, positions) in enumerate(counts)])
  
  "$checksum"
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


