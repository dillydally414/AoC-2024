using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  stones = [parse(Int, n) for n in split(s)]
  counts = [blink(stone, 25) for stone in stones]

  "$(sum(counts))"
end

#=
1/2024 = 0.000494071146
Trends:
    0       -> 1
    1-4     -> multiply by 2024, then split
    5-9     -> multiply by 2024 twice, then split
   10-99    -> split
  100-494   -> multiply by 2024, then split
  495-999   -> multiply by 2024 twice, then split
 1000-9999  -> split
10000-49407 -> multiply by 2024, then split
49408-99999 -> multiply by 2024 twice, then split
=#

blinkmemo = Dict{Tuple{Int, Int}, Int}()

function blink(stone::Int, blinks::Int)::Int
  if blinks == 0
    return 1
  elseif haskey(blinkmemo, (stone, blinks))
    return blinkmemo[(stone, blinks)]
  end

  nextblinks = blinks - 1
  nextstones = []

  if stone == 0
    push!(nextstones, 1)
  elseif ndigits(stone) % 2 == 0
    nums = reverse(digits(stone))
    midpt = Int32(length(nums) / 2)
    stone1, stone2 = 0, 0
    for i in 1:midpt
      stone1 *= 10
      stone1 += nums[i]
      stone2 *= 10
      stone2 += nums[i + midpt]
    end
    push!(nextstones, stone1, stone2)
  else
    if stone <= (10 ^ ndigits(stone)) / 2.024 
      push!(nextstones, stone * 2024)
    else
      if nextblinks == 0
        push!(nextstones, stone * 2024)
      else
        push!(nextstones, stone * 2024 * 2024)
        nextblinks -= 1
      end
    end
  end

  blinkmemo[(stone, blinks)] = sum([blink(n, nextblinks) for n in nextstones])

  blinkmemo[(stone, blinks)]
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

  stones = [parse(Int, n) for n in split(s)]
  counts = [blink(stone, 75) for stone in stones]

  "$(sum(counts))"
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


