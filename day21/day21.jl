using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  codes = split(s)
  numeric = """
  789
  456
  123
   0A"""
  numeric = stack(split(numeric, "\n"), dims=1)
  directional = """
   ^A
  <v>"""
  directional = stack(split(directional, "\n"), dims=1)

  numpad = Dict(char => ((i - 1) % size(numeric, 1), 
                        floor(Int, (i - 1) / size(numeric, 1))) 
                for (i, char) in enumerate(numeric))
  dirpad = Dict(char => ((i - 1) % size(directional, 1), 
                        floor(Int, (i - 1) / size(directional, 1))) 
                for (i, char) in enumerate(directional))

  complexity = 0

  doorbot = 'A'  # numeric
  bot1 = 'A'     # directional, controls bot2
  bot2 = 'A'     # directional, controls doorbot
  for code in codes
    mypresses = 0

    for char in code
      for press2 in moveBotTo(doorbot, char, numpad)
        bot1presses = moveBotTo(bot2, press2, dirpad)
        bot2 = press2
        for press1 in bot1presses
          mypresses += length(moveBotTo(bot1, press1, dirpad))
          bot1 = press1
        end
      end
      doorbot = char
    end

    complexity += mypresses * parse(Int, code[1:3])
  end

  "$complexity"
end

memo = Dict{Tuple{Char, Char}, Vector{Char}}()

function moveBotTo(bot::Char, to::Char, pad::Dict{Char, Tuple{Int, Int}})::Vector{Char}
  if haskey(memo, (bot, to))
    return memo[(bot, to)]
  end
  start, exit = pad[bot], pad[to]
  
  buttons = []
  while start != exit
    if start[2] > exit[2] && pad[' '] != (start[1], exit[2])
      append!(buttons, repeat('<', start[2] - exit[2]))
      start = (start[1], exit[2])
    elseif start[1] < exit[1] && pad[' '] != (exit[1], start[2])
      append!(buttons, repeat('v', exit[1] - start[1]))
      start = (exit[1], start[2])
    elseif start[1] > exit[1] && pad[' '] != (exit[1], start[2])
      append!(buttons, repeat('^', start[1] - exit[1]))
      start = (exit[1], start[2])
    elseif start[2] < exit[2]
      append!(buttons, repeat('>', exit[2] - start[2]))
      start = (start[1], exit[2])
    end
  end
  
  push!(buttons, 'A')
  memo[(bot, to)] = buttons
  buttons
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

  codes = split(s)
  numeric = """
  789
  456
  123
   0A"""
  numeric = stack(split(numeric, "\n"), dims=1)
  directional = """
   ^A
  <v>"""
  directional = stack(split(directional, "\n"), dims=1)

  numpad = Dict(char => ((i - 1) % size(numeric, 1), 
                        floor(Int, (i - 1) / size(numeric, 1))) 
                for (i, char) in enumerate(numeric))
  dirpad = Dict(char => ((i - 1) % size(directional, 1), 
                        floor(Int, (i - 1) / size(directional, 1))) 
                for (i, char) in enumerate(directional))

  complexity = 0
  
  doorbot = 'A'  # numeric
  bots = fill('A', 25)
  for code in codes
    mypresses = 0

    for char in code
      for press in moveBotTo(doorbot, char, numpad)
        mypresses += moveNextBot(bots, 1, press, dirpad)
      end
      doorbot = char
    end

    complexity += mypresses * parse(Int, code[1:3])
  end

  "$complexity"
end

memoct = Dict{Tuple{Char, Int, Char}, Int}()

function moveNextBot(bots::Vector{Char}, curr::Int, to::Char, pad::Dict{Char, Tuple{Int, Int}})::Int
  if curr > length(bots)
    return 1
  end
  t = (bots[curr], curr, to)
  if haskey(memoct, t)
    bots[curr] = to
    return memoct[t]
  end
  nextBotPresses = moveBotTo(bots[curr], to, pad)
  ct = 0
  for press in nextBotPresses
    ct += moveNextBot(bots, curr + 1, press, pad)
  end
  bots[curr] = to
  memoct[t] = ct
  ct
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


