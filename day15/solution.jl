include("../import_data.jl")

import Base: getindex, setindex!, print, println
using Chain

function get_item_locations(
    data::Vector{String},
)::Tuple{Vector{Tuple{Int,Int,Int}},Vector{Tuple{Int,Int}},Int,Int}
    sensors = Vector{Tuple{Int,Int,Int}}()
    beacons = Vector{Tuple{Int,Int}}()
    min_x, max_x = 0, 0
    for line in data
        line_split = @chain begin
            line
            split("Sensor at x=")
            getindex(2)
            split(", y=")
        end
        sensor = (
            parse(Int, line_split[1]),
            parse(Int, split(line_split[2], ":")[1]),
        )
        beacon = (
            parse(Int, split(line_split[2], '=')[2]),
            parse(Int, line_split[3]),
        )
        radius = abs(sensor[1] - beacon[1]) + abs(sensor[2] - beacon[2])
        min_x = minimum((min_x, sensor[1] - radius))
        max_x = maximum((max_x, sensor[1] + radius))
        push!(sensors, (sensor[1], sensor[2], radius))
        push!(beacons, beacon)
    end
    return sensors, beacons, min_x, max_x
end

function task1(example::Bool = false)
    sensors, beacons, min_x, max_x =
        get_item_locations(import_data(15, example))
    y = example ? 10 : 2000000
    not_allowed_count = 0
    beacon_positions = Vector{Int}()
    for beacon in beacons
        if beacon[2] == y && !(beacon[1] in beacon_positions)
            push!(beacon_positions, beacon[1])
        end
    end
    x = min_x
    while x <= max_x
        found = false
        for (sensor_x, sensor_y, radius) in sensors
            if abs(sensor_x - x) + abs(sensor_y - y) <= radius
                not_allowed_count +=
                    sensor_x + radius - abs(sensor_y - y) + 1 - x
                x = sensor_x + radius - abs(sensor_y - y) + 1
                found = true
                break
            end
        end
        if !found
            x += 1
        end
    end
    return not_allowed_count - length(beacon_positions)
end

function task2(example::Bool = false)::Int
    max_coord_value = example ? 20 : 4000000
    sensors_with_radii, beacons, _, _ =
        get_item_locations(import_data(15, example))
    sort!(sensors_with_radii, by = x -> x[3], rev = true)
    for y in 0:max_coord_value
        x = 0
        while x <= max_coord_value
            found = false
            for (sensor_x, sensor_y, radius) in sensors_with_radii
                if abs(sensor_x - x) + abs(sensor_y - y) <= radius
                    x = sensor_x + radius - abs(sensor_y - y) + 1
                    found = true
                    break
                end
            end
            if !found
                return x * 4000000 + y
            end
        end
    end
    error("No solution found")
end

println("Day 15 task 1 example: ", task1(true))
println("Day 15 task 1: ", task1(false))

println("Day 15 task 2 example: ", task2(true))
println("Day 15 task 2: ", task2(false))
