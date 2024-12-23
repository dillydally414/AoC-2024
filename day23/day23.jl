using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  connections = Dict{Tuple{Char, Char}, Set{Tuple{Char, Char}}}()

  for line in split(s)
    comp1, comp2 = [Tuple(sub) for sub in split(line, "-")]
    if haskey(connections, comp1)
      push!(connections[comp1], comp2)
    else
      connections[comp1] = Set([comp2])
    end
    if haskey(connections, comp2)
      push!(connections[comp2], comp1)
    else
      connections[comp2] = Set([comp1])
    end
  end

  triples = Set{NTuple{3, Tuple{Char, Char}}}()

  for (comp1, conns) in connections
    for comp2 in conns
      overlap = intersect(connections[comp1], connections[comp2])
      for comp3 in overlap
        push!(triples, Tuple(sort([comp1, comp2, comp3])))
      end
    end
  end

  valid = sum(t[1][1] == 't' || t[2][1] == 't' || t[3][1] == 't' for t in triples)

  "$valid"
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

  connections = Dict{Tuple{Char, Char}, Set{Tuple{Char, Char}}}()

  for line in split(s)
    comp1, comp2 = [Tuple(sub) for sub in split(line, "-")]
    if haskey(connections, comp1)
      push!(connections[comp1], comp2)
    else
      connections[comp1] = Set([comp2])
    end
    if haskey(connections, comp2)
      push!(connections[comp2], comp1)
    else
      connections[comp2] = Set([comp1])
    end
  end

  largest = Set{Tuple{Char, Char}}()

  for (comp1, conns) in connections
    overlap = Set([comp1])
    for comp2 in conns
      if all(c in connections[comp2] for c in overlap)
        push!(overlap, comp2)
      end
    end
    if length(overlap) > length(largest)
      largest = overlap
    end
  end

  join(sort(["$(pair[1])$(pair[2])" for pair in largest]), ",")
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


