using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  splitstr = split(s, r"(: )|\n+")
  astr, bstr, cstr, progstr = splitstr[2:2:end]

  registers = [parse(Int, n) for n in [astr, bstr, cstr]]
  program = [parse(Int8, n) for n in split(progstr, ",")]
  
  output = runProgram(program, registers)

  join(output, ",")
end

function runProgram(program::Vector{Int8}, registers::Vector{Int})::Vector{Int8}
  ptr = 1
  output = []

  while 1 <= ptr < length(program)
    opcode, operand = program[ptr:ptr + 1]
    if opcode in [0, 6, 7]  # division
      registers[findfirst(r -> r == opcode, [0, 6, 7])] = registers[1] >> getCombo(operand, registers)
    elseif opcode == 1      # bitwise XOR
      registers[2] = xor(registers[2], operand)
    elseif opcode == 2      # mod 8
      registers[2] = getCombo(operand, registers) % 8
    elseif opcode == 3      # jump nonzero
      if registers[1] != 0
        ptr = operand + 1
        continue
      end
    elseif opcode == 4      # bitwise XOR
      registers[2] = xor(registers[2], registers[3])
    elseif opcode == 5      # output mod 8
      push!(output, getCombo(operand, registers) % 8)
    end
    ptr += 2
  end

  output
end

function getCombo(operand::Int8, registers::Vector{Int})::Int
  if 0 <= operand <= 3
    return operand
  elseif 4 <= operand <= 6
    return registers[operand - 3]
  else
    error("Reserved combo operand")
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

  splitstr = split(s, r"(: )|\n+")
  astr, bstr, cstr, progstr = splitstr[2:2:end]

  registers = [parse(Int, n) for n in [astr, bstr, cstr]]
  program = [parse(Int8, n) for n in split(progstr, ",")]
  output = []
  nums = [0]
  for digit in 1:length(program)
    next = vcat([n:n+7 for n in nums * 8]...)
    nums = []
    for areg in next
      output = runProgram(program, [areg, registers[2], registers[3]])
      if output == program[end - digit + 1:end]
        push!(nums, areg)
      end
    end
  end

  "$(first(nums))"
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


