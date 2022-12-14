include("../import_data.jl")

function get_priority(char::Char)::Int
    if islowercase(char)
        return Int(char) - Int('a') + 1
    end
    if isuppercase(char)
        return Int(char) - Int('A') + 27
        return 0
    end
end

function get_rucksacks(example::Bool = false)::Vector{Tuple{String,String}}
    data = import_data(3, example)
    rucksacks::Vector{Tuple{String,String}} = []
    for line in data
        compartment1, compartment2 =
            line[1:Int(length(line) / 2)], line[Int(length(line) / 2)+1:end]
        push!(rucksacks, (compartment1, compartment2))
    end
    return rucksacks
end

function task1(example::Bool = false)::Int
    rucksacks = get_rucksacks(example)
    score::Int = 0
    for (compartment1, compartment2) in rucksacks
        for char in compartment1
            if char in compartment2
                score += get_priority(char)
                break
            end
        end
    end
    return score
end

function task2(example::Bool = false)::Int
    rucksacks = get_rucksacks(example)
    score::Int = 0
    for group_number in 1:length(rucksacks)/3
        group = rucksacks[Int((group_number - 1) * 3 + 1):Int(group_number * 3)]
        for char in group[1][1] * group[1][2]
            if char in group[2][1] * group[2][2] &&
               char in group[3][1] * group[3][2]
                score += get_priority(char)
                println(char, " ", get_priority(char))
                break
            end
        end
    end
    return score
end

println("Day 3 Task 1 example: ", task1(true))
println("Day 3 Task 1: ", task1())

println("Day 3 Task 2 example: ", task2(true))
println("Day 3 Task 2: ", task2())
