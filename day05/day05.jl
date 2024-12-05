using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  orderings = Dict()
  updates = []

  for line in split(s)
    if contains(line, '|')
      prereq, postreq = [parse(Int32, page) for page in split(line, "|")]
      if haskey(orderings, postreq)
        push!(orderings[postreq], prereq)
      else
        orderings[postreq] = [prereq]
      end
    else
      push!(updates, [parse(Int32, page) for page in split(line, ",")])
    end
  end

  sum = 0

  for update in updates
    correct = true
    for (i, page) in enumerate(update)
      if haskey(orderings, page) && !all([prereq in update[1:i] for prereq in orderings[page] if prereq in update])
        correct = false
        break
      end
    end
    if correct
      sum += update[ceil(Int32, length(update)/2)]
    end
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

  orderings = Dict{Int32, Vector{Int32}}()
  updates = []

  for line in split(s)
    if contains(line, '|')
      prereq, postreq = [parse(Int32, page) for page in split(line, "|")]
      if haskey(orderings, postreq)
        push!(orderings[postreq], prereq)
      else
        orderings[postreq] = [prereq]
      end
    else
      push!(updates, [parse(Int32, page) for page in split(line, ",")])
    end
  end

  sum = 0

  for update in updates
    correct = true
    for (i, page) in enumerate(update)
      if haskey(orderings, page) && !all([prereq in update[1:i] for prereq in orderings[page] if prereq in update])
        correct = false
        break
      end
    end
    if !correct
      sum += topsort(update, orderings)[ceil(Int32, length(update)/2)]
    end
  end

  "$sum"
end

function topsort(nodes::Vector{Int32}, edges::Dict{Int32,Vector{Int32}})::Vector{Int32}
  sorted = []
  worklist = copy(nodes)
  curr = -1
  while length(worklist) > 0
    curr = pop!(worklist)
    outedges = []
    if haskey(edges, curr)
      outedges = [out for out in edges[curr] if out in worklist]
    end
    if length(outedges) == 0
      push!(sorted, curr)
    else
      pushfirst!(worklist, curr)
    end
  end
  sorted
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


