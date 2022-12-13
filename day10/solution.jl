include("../import_data.jl")

function apply_command(command::String, current_value::Int)::Vector{Int}
    if command == "noop"
        return [current_value,]
    elseif command[1:4] == "addx"
        add_value = parse(Int, split(command, " ")[2])
        return [current_value, current_value + add_value]
    end
end

function task1(example::Bool=false)::Int
    data = import_data(10, example)
    X_value_during_cycle::Vector{Int} = [1]
    for command in data
        push!(X_value_during_cycle, apply_command(command, X_value_during_cycle[end])...)
    end
    score = 0
    for i in 20:40:220
        # println(i, " ", X_value_during_cycle[i], " ", X_value_during_cycle[i] * i)
        score += X_value_during_cycle[i] * i
    end
    return score
end

function task2(example::Bool=false)
    data = import_data(10, example)
    X_value_during_cycle::Vector{Int} = [1]
    for command in data
        push!(X_value_during_cycle, apply_command(command, X_value_during_cycle[end])...)
    end
    
    for cycle_number in 1:240
        CRT_drawing_in = (cycle_number - 1) % 40
        sprite_position = X_value_during_cycle[cycle_number]
        if abs(sprite_position - CRT_drawing_in) <= 1
            print('#')
        else
            print('.')
        end
        if cycle_number % 40 == 0
            println()
        end
    end
end


println("Day 10, Task 1 example: ", task1(true))
println()
println("Day 10, Task 1: ", task1())

println()

println("Day 10, Task 2 example:", task2(true))
println()
println("Day 10, Task 2:", task2())
