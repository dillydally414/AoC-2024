using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  schematics = split(s, "\n\n")
  locks = [hcat([[c[1] for c in split(row, "")] for row in split(schematic)]...) for schematic in schematics if schematic[1:5] == "#####" && schematic[37:41] == "....."]
  keys = [hcat([[c[1] for c in split(row, "")] for row in split(schematic)]...) for schematic in schematics if schematic[1:5] == "....." && schematic[37:41] == "#####"]

  locks = [[sum(c == '#' for c in col) - 1 for col in eachrow(lock)] for lock in locks]
  keys = [[sum(c == '#' for c in col) - 1 for col in eachrow(key)] for key in keys]

  fit = 0

  for lock in locks, key in keys
    if all(l + k <= 5 for (l, k) in zip(lock, key))
      fit += 1
    end
  end

  "$fit"
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

  # Freebie!

  ""
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



runPart1()


