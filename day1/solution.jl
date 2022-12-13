using DelimitedFiles

include("../import_data.jl")

function get_groups(example::Bool=false)::Vector{Vector{Int}}
    data = import_data(1, example)

    # create empty group and sums as lists of integers
    group::Vector{Int} = []
    groups::Vector{Vector{Int}} = []
    for line in data
        if isempty(line)
            push!(groups, group)
            group = []
        else
            push!(group, parse(Int,line))
        end
    end
    return groups
end

function day1_task1(example::Bool=false)::Int
    groups = get_groups(example)
    return maximum(sum.(groups))
end

function day1_task2(example=false)::Int
    groups = get_groups(example)
    sums::Vector{Int} = [sum(group) for group in groups]
    # find largest three groups by sum
    sorted_sums = sort(sums, rev=true)
    return sum(sorted_sums[1:3])
end

println("Day 1 task 1 example result: ", day1_task1(true))
println("Day 1 task 1 result is: ", day1_task1())

println("Day 1 task 2 example result: ", day1_task2(true))
println("Day 1 task 2 result is: ", day1_task2())
