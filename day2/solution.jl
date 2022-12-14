include("../import_data.jl")

function run_rounds(example::Bool = false, task2_rules::Bool = false)::Int
    data = import_data(2, example)
    score::Int = 0
    for line in data
        them, me = split(line)
        score +=
            task2_rules ? get_new_rules_score(only(them), only(me)) :
            get_score(only(them), only(me))
    end
    return score
end

function get_score(them::Char, me::Char)::Int
    win_score = ((Int(me) - Int(them) - 1) % 3) * 3
    play_score = Int(me) - Int('W')
    return win_score + play_score
end

function get_new_rules_score(them::Char, result::Char)::Int
    win_score = (Int(result) - Int('X')) * 3
    my_play = (Int(them) + Int(result) - 1) % 3 + Int('X')
    play_score = my_play - Int('W')
    return win_score + play_score
end

println("Day 2 task 1 example result: ", run_rounds(true))
println("Day 2 task 1 result is: ", run_rounds())

println("Day 2 task 2 example result: ", run_rounds(true, true))
println("Day 2 task 2 result is: ", run_rounds(false, true))
