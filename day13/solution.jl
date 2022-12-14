include("../import_data.jl")

import Base: push!, print, println

struct List
    list::Vector{Union{List,Int}}
end

function push!(list::List, item)
    push!(list.list, item)
end

function println(list::List)
    print("[")
    print_list(list)
    print("]")
    println()
end

function print(list::List)
    print("[")
    print_list(list)
    print("]")
end

function print_list(list::List)
    for (i, item) in enumerate(list.list)
        if item isa List
            print("[")
            print_list(item)
            print("]")
        else
            print(item)
        end
        if i < length(list.list)
            print(",")
        end
    end
end

function parse_list(line::SubString{String})::Union{List,Int}
    return parse_list(String(line))
end

function parse_list(line::String)::Union{List,Int}
    list = List([])
    skip_number::Int = 0
    for (i, char) in enumerate(line)
        if skip_number > 0
            skip_number -= 1
            continue
        end
        if char == '['
            opened = 0
            closed = 0
            closing_bracket_index = nothing
            for (j, char2) in enumerate(line[i+1:end])
                if char2 == '['
                    opened += 1
                elseif char2 == ']'
                    closed += 1
                end
                if closed > opened
                    closing_bracket_index = j
                    break
                end
            end
            if closing_bracket_index === nothing
                println(line)
                error("No closing bracket found")
            end
            push!(list, parse_list(line[i+1:i+closing_bracket_index-1]))
            skip_number = closing_bracket_index
        elseif char == ','
            continue
        elseif char == ']'
            break
        else
            this_int_string = split(split(line[i:end], ",")[1], "]")[1]
            push!(list, parse(Int, this_int_string))
            skip_number = length(this_int_string) - 1
        end
    end
    return list
end

function get_parsed_list(line::String)::List
    list = parse_list(line[2:end-1])
    return list
end

function in_right_order(left::Int, right::Int)::Union{Bool,Nothing}
    if left == right
        return nothing
    end
    return left < right
end

function in_right_order(left::Int, right::List)::Union{Bool,Nothing}
    return in_right_order(List([left]), right)
end

function in_right_order(left::List, right::Int)::Union{Bool,Nothing}
    return in_right_order(left, List([right]))
end

function in_right_order(left::List, right::List)::Union{Bool,Nothing}
    if length(right.list) == 0
        if length(left.list) > 0
            return false
        else
            return nothing
        end
    end
    for (i, right_item) in enumerate(right.list)
        if i > length(left.list)
            return true
        end
        these_in_order = in_right_order(left.list[i], right_item)
        if these_in_order === nothing
            if i == length(right.list) && i < length(left.list)
                return false
            elseif i == length(right.list) == length(left.list)
                return nothing
            end
            continue
        else
            return these_in_order
        end
    end
    error("got to the strange place!")
end

function task1(example::Bool = false)
    data = import_data(13, example)
    pairs::Vector{Tuple{List,List}} = []
    for index in 1:3:length(data)
        push!(
            pairs,
            (get_parsed_list(data[index]), get_parsed_list(data[index+1])),
        )
    end
    pairs_in_right_order::Vector{Int} = []
    for (i, pair) in enumerate(pairs)
        these_in_order = in_right_order(pair...)
        if these_in_order
            push!(pairs_in_right_order, i)
        end
    end
    println("Pairs in right order: ", pairs_in_right_order)
    return sum(pairs_in_right_order)
end

function task2(example::Bool = false)::Int
    data = import_data(13, example)
    lists::Vector{List} = []
    for line in data
        if line == ""
            continue
        end
        push!(lists, get_parsed_list(line))
    end

    append!(lists, [get_parsed_list("[[2]]"), get_parsed_list("[[6]]")])
    two_index = length(lists) - 1
    six_index = length(lists)
    changes_made::Bool = true
    while changes_made
        changes_made = false
        for (i, list) in enumerate(lists[1:end-1])
            if in_right_order(list, lists[i+1]) === false
                temp = lists[i+1]
                lists[i+1] = lists[i]
                lists[i] = temp
                changes_made = true
                if i == two_index
                    two_index = i + 1
                elseif i + 1 == two_index
                    two_index = i
                end
                if i == six_index
                    six_index = i + 1
                elseif i + 1 == six_index
                    six_index = i
                end
            end
        end
    end
    println("bubble sort complete")

    println("2_index=$two_index, 6_index=$six_index")
    return two_index * six_index
end

println("Day 13, task 1 example: ", task1(true))
println()
println("Day 13, task 1: ", task1())
println()
println("Day 13, task 2 example: ", task2(true))
println()
println("Day 13, task 2: ", task2())
