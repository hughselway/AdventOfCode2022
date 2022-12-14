include("../import_data.jl")

function parse_dataline(line::String)::Vector{Tuple{Int,Int}}
    point_strings = split(line, " -> ")
    points = Vector{Tuple{Int,Int}}()
    for point_string in point_strings
        x_str, y_str = split(point_string, ",")
        push!(points, (parse(Int, x_str), parse(Int, y_str) + 1))
    end
    return points
end

function draw_line_on_map(
    map::AbstractArray{Bool,2},
    start::Tuple{Int,Int},
    stop::Tuple{Int,Int},
)
    if start[1] == stop[1]
        for y in min(start[2], stop[2]):max(start[2], stop[2])
            map[start[1], y] = true
        end
    elseif start[2] == stop[2]
        for x in min(start[1], stop[1]):max(start[1], stop[1])
            map[x, start[2]] = true
        end
    else
        error("Invalid line")
    end
end

function parse_data_to_map(data::Vector{String})::AbstractArray{Bool,2}
    points_per_line = parse_dataline.(data)
    map = falses(
        1000,
        maximum([
            maximum([point[2] for point in points]) for
            points in points_per_line
        ]) + 1,
    )
    for points in points_per_line
        for (i, point) in enumerate(points)
            # print("(", point[1], ", ", point[2], ") ")
            if point[1] > size(map)[1]
                println("Resizing map in x direction to $(point[1])")
                map = cat(map, falses(size(map)[1]...), dims = 1)
            end
            if point[2] > size(map)[2]
                println("Resizing map in y direction to $(point[2])")
                map = cat(map, falses(size(map)[1]...), dims = 2)
            end
            if i == length(points)
                break
            end
            draw_line_on_map(map, points[i], points[i+1])
        end
        # println()
    end
    return map
end

function add_one_grain_of_sand(
    map::AbstractArray{Bool,2},
    sand_source::Tuple{Int,Int},
    settle_on_floor::Bool,
)::Bool
    x, y = sand_source
    if map[x, y]
        # source blocked, can't add any more sand
        return true
    end
    if y == size(map)[2]
        if !settle_on_floor
            # sand escapes, terminate
            return true
        else
            map[x, y] = true
            return false
        end
    end
    if !map[x, y+1]
        return add_one_grain_of_sand(map, (x, y + 1), settle_on_floor)
    elseif !map[x-1, y+1]
        return add_one_grain_of_sand(map, (x - 1, y + 1), settle_on_floor)
    elseif !map[x+1, y+1]
        return add_one_grain_of_sand(map, (x + 1, y + 1), settle_on_floor)
    else
        # sand settles, add more sand (do not terminate)
        map[x, y] = true
        return false
    end
end

function add_sand(
    map::AbstractArray{Bool,2},
    settle_on_floor::Bool = false,
)::Int
    sand_grains_added = 0
    sand_source = (500, 1)
    terminate = false
    while !terminate
        terminate = add_one_grain_of_sand(map, sand_source, settle_on_floor)
        sand_grains_added += 1
    end
    return sand_grains_added - 1
end

function task1(example::Bool = false)
    data = import_data(14, example)
    map = parse_data_to_map(data)
    return add_sand(map)
end

function task2(example::Bool = false)
    data = import_data(14, example)
    map = parse_data_to_map(data)
    sand_added = add_sand(map, true)
    # print map
    for y in 1:size(map)[2]
        for x in 400:600
            if map[x, y]
                print("#")
            else
                print(".")
            end
        end
        println()
    end
    return sand_added
end

# println("Day 14, task 1 example: ", task1(true))
# println("Day 14, task 1: ", task1())

println("Day 14, task 2 example: ", task2(true))
println("Day 14, task 2: ", task2())
