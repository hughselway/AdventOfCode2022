include("../import_data.jl")

struct Monkey
    index::Int
    items::Vector{Int}
    operation::Any
    rule_divisor::Int
    monkey_index_if_true::Int
    monkey_index_if_false::Int
    items_handled::Ref{Int}
end

Monkey(
    index::Int,
    items::Vector{Int},
    operation,
    rule_divisor::Int,
    monkey_index_if_true::Int,
    monkey_index_if_false::Int,
) = Monkey(
    index,
    items,
    operation,
    rule_divisor,
    monkey_index_if_true,
    monkey_index_if_false,
    Ref(0),
)

function add_item(monkey::Monkey, item::Int)
    push!(monkey.items, item)
end

function items_handled(monkey::Monkey)::Int
    return monkey.items_handled[]
end

function get_destination_index(monkey::Monkey, item::Int)::Int
    return item % monkey.rule_divisor == 0 ? monkey.monkey_index_if_true :
           monkey.monkey_index_if_false
end

function parse_data_to_monkeys(data::Vector{String})::Vector{Monkey}
    monkeys = Vector{Monkey}()
    for index in 1:7:length(data)
        monkey_index = div(index, 7)
        items = map(x -> parse(Int, split(x)[end]), split(data[index+1], ","))
        left, operator_string, right = split(split(data[index+2], "=")[end])
        monkey_operator = nothing
        for operator in [+, -, *, /]
            if operator_string == string(operator)
                monkey_operator = operator
            end
        end
        if monkey_operator === nothing
            println("Error: unexpected operator")
        end
        if right == "old" && left == "old"
            monkey_operation = (x -> monkey_operator(x, x))
        elseif left == "old"
            monkey_operation = (x -> monkey_operator(x, parse(Int, right)))
        else
            println("Error: unexpected operation")
        end
        monkey_rule_divisor =
            parse(Int, split(data[index+3], "Test: divisible by ")[end])
        monkey_index_if_true = parse(Int, split(data[index+4])[end])
        monkey_index_if_false = parse(Int, split(data[index+5])[end])

        # println("monkey $(monkey_index) has $(items) and gives to monkey $(monkey_index_if_true) if divisible by $(monkey_rule_divisor) and $(monkey_index_if_false) otherwise")
        push!(
            monkeys,
            Monkey(
                monkey_index,
                items,
                monkey_operation,
                monkey_rule_divisor,
                monkey_index_if_true,
                monkey_index_if_false,
            ),
        )
    end
    return monkeys
end

function inspect(
    monkey_index::Int,
    monkeys::Vector{Monkey},
    divide_by_three::Bool = true,
)
    monkey = monkeys[monkey_index+1]
    while length(monkey.items) > 0
        monkey.items_handled[] += 1
        item = popfirst!(monkey.items)
        item = monkey.operation(item)
        if divide_by_three
            item = div(item, 3)
        end
        new_monkey_index = get_destination_index(monkey, item)
        add_item(monkeys[new_monkey_index+1], item)
        # println("monkey $(monkey.index) gives item $(item) to monkey $(new_monkey_index)")
    end
end

function task1(example::Bool = false)::Int
    data = import_data(11, example)
    monkeys = parse_data_to_monkeys(data)
    for round in 1:20
        for monkey_index in 0:length(monkeys)-1
            inspect(monkey_index, monkeys)
        end
        if round % 5 == 0
            println("after round $(round):")
            for monkey in monkeys
                println("   monkey $(monkey.index) has $(monkey.items)")
            end
            println()
        end
    end
    sorted_monkeys = sort(monkeys, by = items_handled, rev = true)
    return items_handled(sorted_monkeys[1]) * items_handled(sorted_monkeys[2])
end

function product_divisors(monkeys::Vector{Monkey})::Int
    product::Int = 1
    for monkey in monkeys
        product *= monkey.rule_divisor
    end
    return product
end

function reduce_all_items(monkeys::Vector{Monkey}, product::Int)
    for monkey in monkeys
        for i in 1:length(monkey.items)
            monkey.items[i] = monkey.items[i] % product
        end
    end
end

function task2(example::Bool = false)::Int
    data = import_data(11, example)
    monkeys = parse_data_to_monkeys(data)
    product = product_divisors(monkeys)
    for round in 1:10000
        for monkey_index in 0:length(monkeys)-1
            inspect(monkey_index, monkeys, false)
        end
        reduce_all_items(monkeys, product)
        if (round == 20) || (round % 1000 == 0)
            println("after round $(round):")
            for monkey in monkeys
                println("   monkey $(monkey.index) has $(monkey.items)")
            end
            println()
        end
    end
    sorted_monkeys = sort(monkeys, by = items_handled, rev = true)
    return items_handled(sorted_monkeys[1]) * items_handled(sorted_monkeys[2])
end

println("Day 11, task 1 example: $(task1(true))")
println("Day 11, task 1: $(task1())")

println("Day 11, task 2 example: $(task2(true))")
println("Day 11, task 2: $(task2())")
