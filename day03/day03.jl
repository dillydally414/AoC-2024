using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  i = 1
  sum = 0

  while i <= length(s) - 4
    if s[i:i + 3] == "mul("
      i += 4
      commaidx = findfirst(c -> c == ',', s[i + 1:min(i + 4, length(s))])
      if !isnothing(commaidx)
        commaidx = i + commaidx
        closeparenidx = findfirst(c -> c == ')', s[commaidx + 2:min(commaidx + 5, length(s))])
        if !isnothing(closeparenidx)
          closeparenidx = commaidx + closeparenidx
          try
            num1 = parse(Int32, s[i:commaidx - 1])
            num2 = parse(Int32, s[commaidx + 1:closeparenidx])
            sum += num1 * num2
            i = closeparenidx + 1
          catch
          end
        end
      end
    end
    i += 1
  end

  "$sum"
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

  i = 1
  sum = 0
  dont = false

  while i <= length(s) - 6
    if !dont && s[i:i + 3] == "mul("
      i += 4
      commaidx = findfirst(c -> c == ',', s[i + 1:min(i + 4, length(s))])
      if !isnothing(commaidx)
        commaidx = i + commaidx
        closeparenidx = findfirst(c -> c == ')', s[commaidx + 2:min(commaidx + 5, length(s))])
        if !isnothing(closeparenidx)
          closeparenidx = commaidx + closeparenidx
          try
            num1 = parse(Int32, s[i:commaidx - 1])
            num2 = parse(Int32, s[commaidx + 1:closeparenidx])
            sum += num1 * num2
            i = closeparenidx + 1
          catch
          end
        end
      end
    elseif s[i:i + 3] == "do()"
      dont = false
      i += 3
    elseif s[i:i + 6] == "don't()"
      dont = true
      i += 6
    end
    i += 1
  end

  "$sum"
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


