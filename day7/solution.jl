include("../import_data.jl")

struct Directory
    name::String
    parent_directory::Union{Directory,Nothing}
    files::Vector{Tuple{String,Int}}
    child_directories::Vector{Directory}
end

function parse_data(data)::Tuple{Directory,Vector{Directory}}
    root_directory = Directory("/", nothing, [], [])
    current_directory = root_directory
    directory_list::Vector{Directory} = []
    for line in data[2:end]
        # println(line)
        if line[1:4] == "\$ cd"
            if line[6:end] == ".."
                current_directory = current_directory.parent_directory
                continue
            end
            current_directory = current_directory.child_directories[findfirst(
                d -> d.name == line[6:end],
                current_directory.child_directories,
            )]
        elseif line[1:4] == "\$ ls"
            continue
        elseif line[1:3] == "dir"
            push!(
                current_directory.child_directories,
                Directory(line[5:end], current_directory, [], []),
            )
            push!(directory_list, current_directory.child_directories[end])
        else  # file
            size, name = split(line, " ")
            # println(size, " ", name)
            push!(current_directory.files, (name, parse(Int, size)))
        end
    end
    return root_directory, directory_list
end

function calculate_directory_size(directory::Directory)
    size = 0
    for file in directory.files
        size += file[2]
    end
    for child_directory in directory.child_directories
        size += calculate_directory_size(child_directory)
    end
    return size
end

function task1(example::Bool = false)::Int
    data = import_data(7, example)
    root_directory, directory_list = parse_data(data)
    result::Int = 0
    for directory in directory_list
        size = calculate_directory_size(directory)
        if size < 100000
            result += size
        end
    end
    return result
end

function task2(example::Bool = false)::Int
    data = import_data(7, example)
    root_directory, directory_list = parse_data(data)
    current_smallest_sufficient_directory_size::Union{Int,Nothing} = nothing
    space_needed = calculate_directory_size(root_directory) - 40000000
    for directory in directory_list
        size = calculate_directory_size(directory)
        if (
            size > space_needed &&
            current_smallest_sufficient_directory_size === nothing
        ) || (space_needed < size < current_smallest_sufficient_directory_size)
            current_smallest_sufficient_directory_size = size
        end
    end
    return current_smallest_sufficient_directory_size
end

println("Day 7 task 1 example: ", task1(true))
println("Day 7 task 1: ", task1())

println("Day 7 task 2 example: ", task2(true))
println("Day 7 task 2: ", task2())
