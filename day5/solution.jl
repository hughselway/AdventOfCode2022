include("../import_data.jl")

Stacks = Vector{Vector{Char}}

function get_arrangement_and_instruction(example::Bool=false)::Tuple{Vector{String},Vector{String}}
    data = import_data(5, example)
    blank_line_index = findfirst(==(""), data)
    return data[1:blank_line_index-1], data[blank_line_index+1:end]
end

function parse_arrangement_to_stacks(arrangement::Vector{String})::Stacks
    number_of_stacks = parse(Int, split(arrangement[end])[end])
    stacks::Stacks = [[] for _ in 1:number_of_stacks]
    for line in reverse(arrangement)[2:end]
        for (stack_index, stack_value) in enumerate((line[4x-3:4x-1] for x in 1:number_of_stacks))
            if stack_value == "   "
                continue
            end
            push!(stacks[stack_index], stack_value[2])
        end
    end
    return stacks
end

function task1(example::Bool=false)::String
    arrangement, instruction = get_arrangement_and_instruction(example)
    stacks = parse_arrangement_to_stacks(arrangement)
    for line in instruction
        words = split(line)
        number_to_move = parse(Int, words[2])
        from_stack_index = parse(Int, words[4])
        to_stack_index = parse(Int, words[6])
        # println(stacks, " ", number_to_move, " ", from_stack_index, " ", to_stack_index)
        push!(stacks[to_stack_index], (pop!(stacks[from_stack_index]) for _ in 1:number_to_move)...)
    end
    return join((stack[end] for stack in stacks), "")
end

function task2(example::Bool=false)::String
    arrangement, instruction = get_arrangement_and_instruction(example)
    stacks = parse_arrangement_to_stacks(arrangement)
    stacks_to_transfer::Vector{Char} = []
    # println(stacks)
    for line in instruction
        words = split(line)
        number_to_move = parse(Int, words[2])
        from_stack_index = parse(Int, words[4])
        to_stack_index = parse(Int, words[6])
        # println(number_to_move, " ", from_stack_index, " ", to_stack_index)
        push!(stacks_to_transfer, (pop!(stacks[from_stack_index]) for _ in 1:number_to_move)...)
        push!(stacks[to_stack_index], reverse(stacks_to_transfer)...)
        # println(stacks)
        stacks_to_transfer = []
    end
    return join((stack[end] for stack in stacks), "")
end

println("Day 5 task 1 example: ", task1(true))
println("Day 5 task 1: ", task1())

println("Day 5 task 2 example: ", task2(true))
println("Day 5 task 2: ", task2())

