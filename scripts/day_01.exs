# General
{_, {left, right}} =
  File.stream!("assets/test_input_01")
  |> Stream.map(&String.trim(&1))
  |> Stream.map(&String.split(&1))
  |> Stream.map(&Enum.map(&1, fn i -> String.to_integer(i) end))
  |> Enum.flat_map_reduce({[], []}, fn [x, y], {acc_x, acc_y} ->
    new_acc_x = [x | acc_x]
    new_acc_y = [y | acc_y]
    {[x, y], {new_acc_x, new_acc_y}}
  end)

# Part one
task_left_sort = Task.async(fn -> Enum.sort(left) end)
task_right_sort = Task.async(fn -> Enum.sort(right) end)
left_sorted_list = Task.await(task_left_sort)
right_sorted_list = Task.await(task_right_sort)

result_part_one =
  Enum.zip_reduce(left_sorted_list, right_sorted_list, 0, fn x, y, acc ->
    abs(x - y) + acc
  end)

IO.puts("Part one result: #{result_part_one}")

IO.puts("---")

# Part two
right_frequencies = Enum.frequencies(right)

result_part_two =
  Enum.reduce(left, 0, fn i, acc ->
    if right_frequencies[i] do
      i * right_frequencies[i] + acc
    else
      acc
    end
  end)

IO.puts("Part two result: #{result_part_two}")
