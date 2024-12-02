defmodule Day01 do
  use Application

  def start(_type, args) do
    file_input = Enum.at(args, 0)
    IO.puts("Part one result: #{part_one_result(file_input)}")
    IO.puts("---")
    IO.puts("Part two result: #{part_two_result(file_input)}")
    {:ok, self()}
  end

  def part_one_result(file_input) do
    file_input
    |> read_file_input()
    |> parse_read_file_result()
    |> sort_lists()
    |> find_total_distance_between_lists()
  end

  def part_two_result(file_input) do
    file_input
    |> read_file_input()
    |> parse_read_file_result()
    |> find_frequencies()
  end

  defp read_file_input(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.split(&1))
    |> Stream.map(&Enum.map(&1, fn i -> String.to_integer(i) end))
    |> Enum.flat_map_reduce({[], []}, fn [x, y], {acc_x, acc_y} ->
      new_acc_x = [x | acc_x]
      new_acc_y = [y | acc_y]
      {[x, y], {new_acc_x, new_acc_y}}
    end)
  end

  defp parse_read_file_result({_, {left, right}}) do
    {left, right}
  end

  defp sort_lists({left, right}) do
    task_left_sort = Task.async(fn -> Enum.sort(left) end)
    task_right_sort = Task.async(fn -> Enum.sort(right) end)

    left_sorted_list = Task.await(task_left_sort)
    right_sorted_list = Task.await(task_right_sort)

    {left_sorted_list, right_sorted_list}
  end

  defp find_total_distance_between_lists({left, right}) do
    Enum.zip_reduce(left, right, 0, fn x, y, acc ->
      abs(x - y) + acc
    end)
  end

  defp find_frequencies({left, right}) do
    frequencies = Enum.frequencies(right)

    Enum.reduce(left, 0, fn i, acc ->
      if frequencies[i] do
        i * frequencies[i] + acc
      else
        acc
      end
    end)
  end
end
