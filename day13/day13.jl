using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  tokenct = 0

  for machine in split(s, "\n\n")
    lines = split(machine, "\n")
    buttonA = Tuple(parse(Int, n) for n in split(lines[1], r"((X|Y)\+)|(, )")[2:2:4])
    buttonB = Tuple(parse(Int, n) for n in split(lines[2], r"((X|Y)\+)|(, )")[2:2:4])
    prize = Tuple(parse(Int, n) for n in split(lines[3], r"((X|Y)=)|(, )")[2:2:4])
    memo = fill(NaN, (prize[1] + 1, prize[2] + 1))
    memo[1, 1] = 0.0
    # println("Button A: $buttonA\nButton B: $buttonB\nPrize: $prize\n")
    res = opt!((prize[1] + 1, prize[2] + 1), buttonA, buttonB, memo)
    # println(res)
    if !isnan(res) && res != Inf
      println("$prize: $res")
      tokenct += Int(res)
    end
  end

  "$tokenct"
end

function opt!(target::Tuple{Int, Int}, buttonA::Tuple{Int, Int}, buttonB::Tuple{Int, Int}, memo::Matrix{Float64})::Float64
  # println(target)
  if target[1] < 1 || target[2] < 1
    return Inf
  elseif !isnan(memo[target[1], target[2]])
    # println(memo[target[1], target[2]])
    return memo[target[1], target[2]]
  else 
    a = opt!((target[1] - buttonA[1], target[2] - buttonA[2]), buttonA, buttonB, memo) + 3
    b = opt!((target[1] - buttonB[1], target[2] - buttonB[2]), buttonA, buttonB, memo) + 1
    best = min(a, b)
    memo[target[1], target[2]] = best
    return best
  end
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

  tokenct = 0

  for machine in split(s, "\n\n")
    lines = split(machine, "\n")
    buttonA = Tuple(parse(Int, n) for n in split(lines[1], r"((X|Y)\+)|(, )")[2:2:4])
    buttonB = Tuple(parse(Int, n) for n in split(lines[2], r"((X|Y)\+)|(, )")[2:2:4])
    prize = Tuple(parse(Int, n) for n in split(lines[3], r"((X|Y)=)|(, )")[2:2:4])
    prize = (prize[1] + 10000000000000, prize[2] + 10000000000000)

    # How many presses of B:A to make an equivalent change in X?
    xRatio = buttonB[1] // buttonA[1]

    # Lowest number of B presses to find a satisfactory solution for X
    xStart = findfirst(x -> (prize[1] - (buttonB[1] * x)) % buttonA[1] == 0,
                    0:denominator(xRatio))
    if isnothing(xStart)
      continue
    end

    # Calculate how much the Y solution is off by
    b = xStart - 1
    a = Int((prize[1] - (buttonB[1] * b)) / buttonA[1])
    yDiff = a * buttonA[2] + b * buttonB[2] - prize[2]

    # Correct the Y solution by finding the change in b presses that does not change X solution
    fix = yDiff / (buttonA[2] * xRatio - buttonB[2])
    if isinteger(fix)
      b += Int(fix)
      a = Int((prize[1] - (buttonB[1] * b)) / buttonA[1])
      tokenct += a * 3 + b
    end
  end

"$tokenct"
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

