using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);
  left, right = [], []

  for (i, num) in enumerate(split(s))
    if i % 2 == 0
      push!(left, parse(Int, num))
    else
      push!(right, parse(Int, num))
    end
  end

  left, right = sort(left), sort(right)

  distances = sum([abs(r - l) for (l, r) in zip(left, right)])

  "$distances"
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
  left = []
  counts = Dict{Int64,Int64}()

  for (i, num) in enumerate(split(s))
    n = parse(Int, num)
    if i % 2 == 0
      push!(left, n)
    else
      if haskey(counts, n)
        counts[n] = counts[n] + 1
      else
        counts[n] = 1
      end
    end
  end

  similarity = sum([l * counts[l] for l in left if haskey(counts, l)])

  "$similarity"
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


