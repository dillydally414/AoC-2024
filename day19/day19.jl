using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  patterns, designs = [split(part, r"(, )|\n") for part in split(s, "\n\n")]

  possible = 0

  for design in designs
    subdesign = fill(false, (length(design)))
    for i in 1:length(design)
      subdesign[i] = any(p -> (length(p) == i || 
                                (i > length(p) && subdesign[i - length(p)])
                              ) && p == design[i - length(p) + 1:i], 
                        patterns)
    end
    if subdesign[end]
      possible += 1
    end
  end

  "$possible"
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

  patterns, designs = [split(part, r"(, )|\n") for part in split(s, "\n\n")]

  possible = 0

  for design in designs
    subdesign = fill(0, (length(design) + 1))
    subdesign[1] = 1
    for i in 2:length(subdesign)
      subdesign[i] = sum(Int[subdesign[i - length(p)] for p in patterns if (i > length(p) && p == design[i - length(p):i - 1])])
    end
    possible += subdesign[end]
  end

  "$possible"
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


