function import_data(day::Int, example::Bool=false)::Array{String, 1}
    filepath = example ? "day$(day)/example_data.txt" : "day$(day)/data.txt"
    return readlines(filepath)
end
