function task1(example::Bool=false, example_number::Int=1)::Int
    data = example ? readlines("day6/example_data.txt")[example_number] : read("day6/data.txt")
    for position in 4:length(data)
        if length(unique(data[position - 3:position])) == 4
            # println(unique(data[position - 3:position]))
            return position
        end
    end
end

function task2(example::Bool=false, example_number::Int=1)::Int
    data = example ? readlines("day6/example_data.txt")[example_number] : read("day6/data.txt")
    for position in 14:length(data)
        if length(unique(data[position - 13:position])) == 14
            println(unique(data[position - 3:position]))
            return position
        end
    end
end

for example_number in 1:5
    println("Day 6 Task 1 example $example_number: ", task1(true, example_number))
end
println("Day 6 Task 1: ", task1())

for example_number in 1:5
    println("Day 6 Task 2 example $example_number: ", task2(true, example_number))
end
println("Day 6 Task 2: ", task2())
