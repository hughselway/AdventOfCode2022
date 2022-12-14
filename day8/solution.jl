include("../import_data.jl")

function update_visibility(
    tree_heights::Array{Int64,2},
    visible_points::Array{Bool,2},
    side_length::Int,
    reverse::Bool,
    vertical::Bool,
)::Array{Bool,2}
    for i in 1:side_length
        current_height::Int = 0
        for j in (reverse ? (side_length:-1:1) : (1:side_length))
            coord_1 = vertical ? j : i
            coord_2 = vertical ? i : j
            # print("(", coord_1, ", ", coord_2, ")  ")
            if (tree_heights[coord_1, coord_2] > current_height) ||
               (j == (reverse ? side_length : 1))
                # print("X")
                current_height = tree_heights[coord_1, coord_2]
                visible_points[coord_1, coord_2] = true
            end
        end
        # println()
    end
    return visible_points
end

function task1(example::Bool = false)
    data = import_data(8, example)
    println(data)
    side_length = length(data[1])
    tree_heights = Array{Int,2}(undef, side_length, side_length)
    visible_points = Array{Bool,2}(undef, side_length, side_length)
    for i in 1:side_length
        for j in 1:side_length
            tree_heights[i, j] = parse(Int, data[i][j])
            visible_points[i, j] = false
            print(tree_heights[i, j])
        end
        println()
    end
    println()

    for vertical in [false, true]
        for reverse in [false, true]
            # println()
            # println("Vertical: ", vertical, ", reverse: ", reverse)
            visible_points = update_visibility(
                tree_heights,
                visible_points,
                side_length,
                reverse,
                vertical,
            )
        end
    end

    for i in 1:side_length
        for j in 1:side_length
            if visible_points[i, j]
                print("#")
            else
                print(".")
            end
        end
        println()
    end

    count = 0
    for i in 1:side_length
        for j in 1:side_length
            if visible_points[i, j]
                count += 1
            end
        end
    end
    return count
end

function viewing_distance(i, j, tree_heights, side_length, vertical, reverse)
    starting_value = vertical ? i : j
    for k in
        (reverse ? (starting_value-1:-1:1) : (starting_value+1:side_length))
        coord_1, coord_2 = vertical ? (k, j) : (i, k)
        if tree_heights[i, j] <= tree_heights[coord_1, coord_2]
            return abs(k - starting_value)
        end
    end
    return reverse ? starting_value - 1 : side_length - starting_value
end

function scenic_score(i, j, tree_heights, side_length)
    score = 1
    for vertical in (false, true)
        for reverse in (false, true)
            # print(viewing_distance(i, j, tree_heights, side_length, vertical, reverse))
            score *= viewing_distance(
                i,
                j,
                tree_heights,
                side_length,
                vertical,
                reverse,
            )
        end
    end
    return score
end

function task2(example::Bool = false)::Int
    data = import_data(8, example)
    side_length = length(data[1])
    tree_heights = Array{Int,2}(undef, side_length, side_length)
    for i in 1:side_length
        for j in 1:side_length
            tree_heights[i, j] = parse(Int, data[i][j])
            # print(tree_heights[i, j])
        end
        # println()
    end

    max_score = 0
    max_score_i = 0
    max_score_j = 0
    for i in 1:side_length
        for j in 1:side_length
            score = scenic_score(i, j, tree_heights, side_length)
            # print("   ")
            if score > max_score
                max_score = score
                max_score_i = i
                max_score_j = j
            end
        end
        # println()
    end
    println("max score at ", max_score_i, ", ", max_score_j)
    return max_score
end

println("Day 8 task 1 example: ", task1(true))
println("Day 8 task 1: ", task1())

println("Day 8 task 2 example: ", task2(true))
println("Day 8 task 2: ", task2())
