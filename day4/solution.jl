include("../import_data.jl")

function get_ranges_from_line(
    line::String,
)::Tuple{Tuple{Int,Int},Tuple{Int,Int}}
    ranges::Vector{Tuple{Int,Int}} = []
    for range in split(line, ",")
        range = split(range, "-")
        push!(ranges, (parse(Int, range[1]), parse(Int, range[2])))
    end
    return ranges[1], ranges[2]
end

function get_ranges(
    example::Bool = false,
)::Vector{Tuple{Tuple{Int,Int},Tuple{Int,Int}}}
    data = import_data(4, example)
    ranges::Vector{Tuple{Tuple{Int,Int},Tuple{Int,Int}}} = []
    for line in data
        push!(ranges, get_ranges_from_line(line))
    end
    return ranges
end

function task1(example::Bool = false)::Int
    ranges = get_ranges(example)
    score::Int = 0
    for (range1, range2) in ranges
        if (range1[1] <= range2[1] && range1[2] >= range2[2]) ||
           (range2[1] <= range1[1] && range2[2] >= range1[2])
            score += 1
            # println("Fully contained: ", range1, " ", range2)
        end
    end
    return score
end

function task2(example::Bool = false)::Int
    ranges = get_ranges(example)
    score::Int = 0
    for (range1, range2) in ranges
        if (range1[2] >= range2[1]) && (range2[2] >= range1[1])
            score += 1
            # println("overlap: ", range1, " ", range2)
        end
    end
    return score
end

println("Day 4, Task 1 example: ", task1(true))
println("Day 4, Task 1: ", task1())

println("Day 4, Task 2 example: ", task2(true))
println("Day 4, Task 2: ", task2())
