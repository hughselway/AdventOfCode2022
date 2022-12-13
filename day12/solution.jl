include("../import_data.jl")

function parse_map(data::Vector{String})::Tuple{Array{Int,2}, Tuple{Int,Int}, Tuple{Int,Int}}
    map = Array{Int,2}(undef, length(data[1]), length(data))
    starting_position = nothing
    ending_position = nothing
    for (y, line) in enumerate(data)
        for (x, char) in enumerate(line)
            if char == 'S'
                starting_position = (x, y)
                map[x, y] = 0
            elseif char == 'E'
                ending_position = (x, y)
                map[x, y] = Int('z') - Int('a')
            else
                map[x, y] = Int(char) - Int('a')
            end
        end
    end
    return map, starting_position, ending_position
end

function task1(example::Bool=false)::Int
    data = import_data(12, example)
    map, starting_position, ending_position = parse_map(data)

    dist = fill(typemax(Int), size(map))
    dist[starting_position...] = 0

    queue = [starting_position]
    while !isempty(queue)
        queue = sort(queue, by = x -> dist[x...])
        x, y = popfirst!(queue)
        println("x: $x, y: $y, dist: $(dist[x, y])")
        if (x, y) == ending_position
            return dist[x, y]
        end
        for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
            x2 = x + dx
            y2 = y + dy
            point_on_map = x2 > 0 && x2 <= size(map, 1) && y2 > 0 && y2 <= size(map, 2)
            if point_on_map 
                point_accessible = (map[x2, y2] - map[x, y] <= 1)
                if point_accessible
                    if dist[x2, y2] > dist[x, y] + 1
                        dist[x2, y2] = dist[x, y] + 1
                        push!(queue, (x2, y2))
                    end
                end
            end
        end
    end
    return -1
end

function task2(example::Bool=false)::Int
    data = import_data(12, example)
    map, starting_position, ending_position = parse_map(data)

    dist = fill(typemax(Int), size(map))
    dist[ending_position...] = 0

    queue = [ending_position]
    distances_to_a_heights = Vector{Int}()
    while !isempty(queue)
        queue = sort(queue, by = x -> dist[x...])
        x, y = popfirst!(queue)
        println("x: $x, y: $y, dist: $(dist[x, y])")
        if map[x, y] == 0 && !(dist[x, y] in distances_to_a_heights)
            push!(distances_to_a_heights, dist[x, y])
        end
        for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
            x2 = x + dx
            y2 = y + dy
            point_on_map = x2 > 0 && x2 <= size(map, 1) && y2 > 0 && y2 <= size(map, 2)
            if point_on_map 
                point_accessible = (map[x, y] - map[x2, y2] <= 1)
                if point_accessible
                    if dist[x2, y2] > dist[x, y] + 1
                        dist[x2, y2] = dist[x, y] + 1
                        push!(queue, (x2, y2))
                    end
                end
            end
        end
    end
    return minimum(distances_to_a_heights)
end

println("Day 12 task 1 example: $(task1(true))")
println("Day 12 task 1: $(task1())")

println("Day 12 task 2 example: $(task2(true))")
println("Day 12 task 2: $(task2())")
