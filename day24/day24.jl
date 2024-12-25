using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  wirestr, gatestr = split(s, "\n\n")
  wires = Dict{String, Bool}(line[1:3] => parse(Bool, line[6]) for line in split(wirestr, "\n"))
  gates = [Tuple(split(line, r" (-> )?")) for line in split(gatestr, "\n")]

  outwires = applyGates!(wires, gates)

  dec = scoreWires(outwires, 'z')

  "$dec"
end

function applyGates!(wires::Dict{String, Bool}, gates::Vector{NTuple{4, SubString{String}}})::Dict{String, Bool}
  wires = copy(wires)
  gates = copy(gates)

  while length(gates) > 0
    gate = pop!(gates)
    first, op, second, out = gate
    if haskey(wires, first) && haskey(wires, second)
      if op == "AND"
        wires[out] = wires[first] && wires[second]
      elseif op == "OR"
        wires[out] = wires[first] || wires[second]
      elseif op == "XOR"
        wires[out] = xor(wires[first], wires[second])
      end
    else
      pushfirst!(gates, gate)
    end
  end

  wires
end

function scoreWires(wires::Dict{String, Bool}, letter::Char)::Int
  bools = []

  z = 0
  zwire = "$letter$(lpad(z, 2, "0"))"
  while haskey(wires, zwire)
    push!(bools, wires[zwire])
    z += 1
    zwire = "$letter$(lpad(z, 2, "0"))"
  end

  dec = 0
  for i in reverse(bools)
    dec *= 2
    dec += i
  end

  dec
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

  wirestr, gatestr = split(s, "\n\n")
  wires = Dict{String, Bool}(line[1:3] => parse(Bool, line[6]) for line in split(wirestr, "\n"))
  gates = [Tuple(split(line, r" (-> )?")) for line in split(gatestr, "\n")]
  for (i, (first, op, second, out)) in enumerate(gates)
    if second < first
      gates[i] = (second, op, first, out)
    end
  end

  xors = []
  ands = []

  #=
  x00 XOR y00 -> z00     <- set current value with single XOR, x y
  x00 AND y00 -> qtf     <- carry value (x && y)
  x01 XOR y01 -> wqc     <- store xor for next carry
  wqc XOR qtf -> z01     <- set current value with triple XOR, x y carry
  x01 AND y01 -> tnr     <- carry value (x && y)
  wqc AND qtf -> djn     <- carry value (carry && (x xor y))
  djn  OR tnr -> cpb     <- carry value (apply or to the previous 2)
  x02 XOR y02 -> wmr     <- store xor for next value
  cpb XOR wmr -> z02     <- set current value with triple XOR, x y carry
  wmr AND cpb -> vtm     
  fwt  OR vtm -> tdw     Pattern starts to repeat here on out
  tdw XOR vrk -> z03
  =#

  for (_, op, _, out) in sort(filter(g -> g[1][1] == 'x' || g[3][1] == 'x', gates))
    if op == "AND"
      push!(ands, out)
    elseif op == "XOR"
      push!(xors, out)
    end
  end

  mistakes = []

  prevcarry1 = ands[1]         # qtf
  prevcarry2 = xors[2]         # wqc
  for i in 2:length(ands) - 1
    z = "z$(lpad(i - 1, 2, "0"))"
    println("--- Currently examining $z. Carry wires are $prevcarry1, $prevcarry2 ---")
    nextcarry1 = ands[i]       # tnr
    nextcarry2 = xors[i + 1]   # wmr
    ops = filter(g -> (g[1] == prevcarry1 && g[3] == prevcarry2) || (g[3] == prevcarry1 && g[1] == prevcarry2), gates)
    xoridx = findfirst(g -> g[2] == "XOR", ops)
    if !isnothing(xoridx) && ops[xoridx][4] != z
      # carry XORs should result in an assignment to z??
      xorop = ops[xoridx]
      println("Should have $prevcarry1 XOR $prevcarry2 -> $z in gates")
      swapWires!(gates, xorop[4], z)
      push!(mistakes, z, xorop[4])
      ops = filter(g -> (g[1] == prevcarry1 && g[3] == prevcarry2) || (g[3] == prevcarry1 && g[1] == prevcarry2), gates)
      replace!(ands, xorop[4] => z, z => xorop[4])
      replace!(xors, xorop[4] => z, z => xorop[4])
      nextcarry1 = ands[i]     
      nextcarry2 = xors[i + 1]  
    end
    andidx = findfirst(g -> g[2] == "AND", ops)
    if isnothing(andidx)
      # carries should also be ANDed for intermediate calculation. 
      # Otherwise, one of them is a false carry
      println("Should have $prevcarry1 AND $prevcarry2 -> ??? in gates")
      andidx = findfirst(g -> g[2] == "AND" && (g[1] == prevcarry1 || g[3] == prevcarry1 || g[1] == prevcarry2 || g[3] == prevcarry2), gates)
      andgate = gates[andidx]
      if andgate[1] == prevcarry1 || andgate[3] == prevcarry1
        trueand = andgate[1:2:3][findfirst(w -> w != prevcarry1, andgate[1:2:3])]
        swapWires!(gates, trueand, prevcarry2)
        push!(mistakes, trueand, prevcarry2)
        replace!(ands, trueand => prevcarry2, prevcarry2 => trueand)
        replace!(xors, trueand => prevcarry2, prevcarry2 => trueand)
        prevcarry2 = trueand
      else
        trueand = andgate[1:2:3][findfirst(w -> w != prevcarry2, andgate[1:2:3])]
        swapWires!(gates, trueand, prevcarry1)
        push!(mistakes, trueand, prevcarry1)
        replace!(ands, trueand => prevcarry1, prevcarry1 => trueand)
        replace!(xors, trueand => prevcarry1, prevcarry1 => trueand)
        prevcarry1 = trueand
      end
      nextcarry1 = ands[i]     
      nextcarry2 = xors[i + 1]  
      ops = filter(g -> (g[1] == prevcarry1 && g[3] == prevcarry2) || (g[3] == prevcarry1 && g[1] == prevcarry2), gates)
      andidx = findfirst(g -> g[2] == "AND", ops)
    end
    orcarry = ops[andidx][4]      # djn
    nextor = findfirst(g -> (g[1] == nextcarry1 && g[3] == orcarry) || (g[3] == nextcarry1 && g[1] == orcarry), gates)
    if isnothing(nextor)
      # They were nice and didn't mess with my ORs, but it would be similar to AND.
      println("Should have $nextcarry1/$nextcarry2 OR $orcarry -> ??? in gates")
    else
      nextcarry1 = gates[nextor][4]
    end
    prevcarry1 = nextcarry1
    prevcarry2 = nextcarry2
  end

  join(sort(mistakes), ",")
end

function swapWires!(gates::Vector{NTuple{4, SubString{String}}}, wire1::AbstractString, wire2::AbstractString)
  wire1idx = findfirst(g -> g[4] == wire1, gates)
  wire1gate = popat!(gates, wire1idx)
  wire2idx = findfirst(g -> g[4] == wire2, gates)
  wire2gate = popat!(gates, wire2idx)
  println("Removed $wire1, $wire2")
  push!(gates, (wire1gate[1], wire1gate[2], wire1gate[3], wire2))
  push!(gates, (wire2gate[1], wire2gate[2], wire2gate[3], wire1))
  println("Added $(gates[end - 1:end])")
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


