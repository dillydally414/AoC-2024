using Test

function part1(file::AbstractString)::AbstractString
  s = read(file, String);

  rows, cols = (-1, -1)
  antennas = Dict{Char, Vector{Tuple{Int32, Int32}}}()

  for (row, line) in enumerate(split(s))
    rows = row
    cols = length(line)
    for (col, char) in enumerate(line)
      if char != '.'
        if haskey(antennas, char)
          push!(antennas[char], (row, col))
        else
          antennas[char] = [(row, col)]
        end
      end
    end
  end

  antinodes = Set{Tuple{Int32, Int32}}()

  for (_frequency, locs) in antennas
    for (idx, i) in enumerate(locs), j in locs[idx + 1:end]
      rowoff, coloff = i[1] - j[1], i[2] - j[2]
      if coloff != 0 && coloff != 0
        anti1 = i[1] + rowoff, i[2] + coloff
        anti2 = j[1] - rowoff, j[2] - coloff
        if 1 <= anti1[1] <= rows && 1 <= anti1[2] <= cols
          push!(antinodes, anti1)
        end
        if 1 <= anti2[1] <= rows && 1 <= anti2[2] <= cols
          push!(antinodes, anti2)
        end
      end
    end
  end

  "$(length(antinodes))"
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

  rows, cols = (-1, -1)
  antennas = Dict{Char, Vector{Tuple{Int32, Int32}}}()

  for (row, line) in enumerate(split(s))
    rows = row
    cols = length(line)
    for (col, char) in enumerate(line)
      if char != '.'
        if haskey(antennas, char)
          push!(antennas[char], (row, col))
        else
          antennas[char] = [(row, col)]
        end
      end
    end
  end

  antinodes = Set{Tuple{Int32, Int32}}()

  for (_frequency, locs) in antennas
    for (idx, i) in enumerate(locs), j in locs[idx + 1:end]
      rowoff, coloff = i[1] - j[1], i[2] - j[2]
      rowsabove = Int32(floor((i[1] - 1) / abs(rowoff)))
      rowsbelow = Int32(floor((rows - i[1]) / abs(rowoff)))
      colsleft = Int32(floor((i[2] - 1) / abs(coloff)))
      colsright = Int32(floor((cols - i[2]) / abs(coloff)))
      if rowoff * coloff < 0
        rowsabove, rowsbelow = rowsbelow, rowsabove
      else
        rowoff, coloff = abs(rowoff), abs(coloff)
      end
      slotsbefore, slotsafter = min(rowsabove, colsleft), min(rowsbelow, colsright)
      for scaleoff in -slotsbefore:slotsafter
        anti = (i[1] + rowoff * scaleoff, i[2] + coloff * scaleoff)
        push!(antinodes, anti)
      end
    end
  end

  "$(length(antinodes))"
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


