using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  dims = Tuple(parse(Int, n) for n in split(s)[1:2])

  topleft, topright, botleft, botright = 0, 0, 0, 0

  for robot in split(s, "\n")[2:end]
    line = split(robot, r"=|,| ")
    pos = Tuple(parse(Int, n) for n in line[2:3])
    vel = Tuple(parse(Int, n) for n in line[5:6])

    pos100 = (pos[1] + vel[1] * 100, pos[2] + vel[2] * 100)
    pos100 = (pos100[1] + dims[1] * (ceil(Int, abs(pos100[1] / dims[1]))), 
              pos100[2] + dims[2] * (ceil(Int, abs(pos100[2] / dims[2]))))
    pos100 = (pos100[1] % dims[1], pos100[2] % dims[2])
    left = sign(pos100[1] - floor(Int, dims[1] / 2))
    upper = sign(pos100[2] - floor(Int, dims[2] / 2))
    if upper < 0 && left < 0
      topleft += 1
    elseif upper < 0 && left > 0
      topright += 1
    elseif upper > 0 && left < 0
      botleft += 1
    elseif upper > 0 && left > 0
      botright += 1
    end
  end
  
  safety = topleft * topright * botleft * botright
  "$safety"
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

  dims = Tuple(parse(Int, n) for n in split(s)[1:2])
  loop = dims[1] * dims[2]
  robotpos = []
  robotvel = []

  for robot in split(s, "\n")[2:end]
    line = split(robot, r"=|,| ")
    push!(robotpos, Tuple(parse(Int, n) for n in line[2:3]))
    vel = Tuple(parse(Int, n) for n in line[5:6])
    push!(robotvel, ((vel[1] + dims[1]) % dims[1], (vel[2] + dims[2]) % dims[2]))
  end

  bestscore = -1
  best = -1

  for i in 1:loop
    allpos = Set{Tuple{Int, Int}}([
      ((pos[1] + vel[1] * i) % dims[1], (pos[2] + vel[2] * i) % dims[2])
    for (pos, vel) in zip(robotpos, robotvel)])
    score = sum(sum([(p[1] + offx, p[2] + offy) in allpos for offx in -1:1, offy in -1:1])
               for p in allpos)
    if score > bestscore
      bestscore = score
      best = i
    end
  end

  tree = Set{Tuple{Int, Int}}([
      ((pos[1] + vel[1] * best) % dims[1], (pos[2] + vel[2] * best) % dims[2])
    for (pos, vel) in zip(robotpos, robotvel)])

  printBots(tree, dims)

  "$best"
end

function printBots(bots::Set{Tuple{Int, Int}}, dims::Tuple{Int, Int})
  for row in 0:dims[2] - 1
    for col in 0:dims[1] - 1
      if (row, col) in bots
        print("#")
      else
        print(".")
      end
    end
    println()
  end
  println()
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
