include("../import_data.jl")

mutable struct Coords
    x::Int
    y::Int
end

function move_one_step(head_coordinate::Coords, direction::Char)
    if direction == 'U'
        head_coordinate.y += 1
    elseif direction == 'D'
        head_coordinate.y -= 1
    elseif direction == 'L'
        head_coordinate.x -= 1
    elseif direction == 'R'
        head_coordinate.x += 1
    end
end

function update_tail(head::Coords, tail::Coords)
    if abs(head.x - tail.x) > 1
        tail.x += sign(head.x - tail.x)
        if tail.y != head.y
            tail.y += sign(head.y - tail.y)
        end
    elseif abs(head.y - tail.y) > 1
        tail.y += sign(head.y - tail.y)
        if tail.x != head.x
            tail.x += sign(head.x - tail.x)
        end
    end
end

function task1(example::Bool=false)::Int
    data = import_data(9, example)
    head::Coords = Coords(0, 0)
    tail::Coords = Coords(0, 0)

    tail_locations = Vector{Tuple{Int,Int}}()

    for line in data
        direction, moves_text = split(line)
        moves = parse(Int, moves_text)

        for i in 1:moves
            move_one_step(head, only(direction))
            update_tail(head, tail)
            tail_tuple=(tail.x, tail.y)
            if !(tail_tuple in tail_locations)
                push!(tail_locations, tail_tuple)
            end
        end
    end
    return length(tail_locations)
end

function print_tail_locations(head::Coords, tails::Vector{Coords})
    for tail in tails
        print("(", tail.x, ", ", tail.y, ")  ")
    end
    println()
end

function task2(example::Bool=false)::Int
    data = import_data(9, example)
    head::Coords = Coords(0, 0)
    tails::Vector{Coords} = [Coords(0, 0) for i in 1:9]
    tail_locations = Vector{Tuple{Int,Int}}()

    for line in data
        direction, moves_text = split(line)
        moves = parse(Int, moves_text)

        for i in 1:moves
            move_one_step(head, only(direction))
            update_tail(head, tails[1]) 
            for tail_index in 2:9
                update_tail(tails[tail_index-1], tails[tail_index])
            end
            tail_tuple=(tails[9].x, tails[9].y)
            if !(tail_tuple in tail_locations)
                push!(tail_locations, tail_tuple)
            end
        end
    end
    return length(tail_locations)
end

println("Day 9 task 1 example: ", task1(true))
println("Day 9 task 1: ", task1())

println("Day 9 task 2 example: ", task2(true))
println("Day 9 task 2: ", task2())
