using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  calibration = 0

  for line in split(s, "\n")
    expected, nums... = [parse(Int64, n) for n in split(replace(line, ":" => ""))]
    poss = [nums[1]]
    for n in nums[2:end]
      poss = union([p * n for p in poss], [p + n for p in poss])
    end
    if expected in poss
      calibration += expected
    end
  end

  "$calibration"
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

  calibration = 0

  for line in split(s, "\n")
    expected, nums... = [parse(Int64, n) for n in split(replace(line, ":" => ""))]
    poss = [nums[1]]
    for n in nums[2:end]
      poss = union([p * n for p in poss], 
        [p + n for p in poss],
        [parse(Int64, "$p$n") for p in poss])
      filter!(n -> n <= expected, poss)
    end
    if expected in poss
      calibration += expected
    end
  end

  "$calibration"
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


