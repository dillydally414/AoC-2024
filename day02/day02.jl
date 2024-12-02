using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  count = 0

  for report in split(s, "\n")
    levels = [parse(Int32, l) for l in split(report)]
    if isSafe(levels)
      count = count + 1
    end
  end

  "$count"
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

function isSafe(levels::Vector{Int32})::Bool
  increasing = levels[2] > levels[1]
  safe = true
  prevLevel = levels[1]
  for level in levels[2:end]
      if (!((increasing && 1 <= level - prevLevel <= 3) ||
        (!increasing && 1 <= prevLevel - level <= 3)))
        safe = false
        break
      end
    prevLevel = level
  end
  safe
end

function part2(file::AbstractString)::AbstractString
  s = read(file, String);

  count = 0

  for report in split(s, "\n")
    levels = [parse(Int32, l) for l in split(report)]
    if isSafe(levels)
      count = count + 1
    else
      for i in 1:length(levels)
        toRemove = copy(levels)
        splice!(toRemove, i)
        if isSafe(toRemove)
          count = count + 1
          break
        end
      end
    end
  end

  "$count"
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


