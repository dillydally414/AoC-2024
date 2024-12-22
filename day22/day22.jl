using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  init = [parse(Int, n) for n in split(s)]
  secrets = 0

  for num in init
    curr = num
    for i in 1:2000
      curr = xor(curr, curr << 6) % (1 << 24)
      curr = xor(curr, curr >> 5) % (1 << 24)
      curr = xor(curr, curr << 11) % (1 << 24)
    end
    secrets += curr
  end

  "$secrets"
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

  init = [parse(Int, n) for n in split(s)]
  sequences = Dict{Tuple{Int, Int, Int, Int},Int}()

  for num in init
    curr = num
    running = zeros(Int, (2000))
    prices = zeros(Int, (2001))
    numseqs = Set{Tuple{Int, Int, Int, Int}}()
    prices[1] = num % 10
    for i in 1:2000
      curr = xor(curr, curr << 6) % (1 << 24)
      curr = xor(curr, curr >> 5) % (1 << 24)
      curr = xor(curr, curr << 11) % (1 << 24)
      prices[i + 1] = curr % 10
      running[i] = prices[i + 1] - prices[i]
    end
    for i in 4:2000
      t = Tuple(running[i - 3:i])
      if t in numseqs
        continue
      end
      push!(numseqs, t)
      if haskey(sequences, t)
        sequences[t] += prices[i + 1]
      else
        sequences[t] = prices[i + 1]
      end
    end
  end

  bananas = maximum(e -> e[2], sequences)

  "$bananas"
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


