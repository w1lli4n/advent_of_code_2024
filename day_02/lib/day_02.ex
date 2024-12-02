defmodule Day02 do
  use Application

  def start(_type, args) do
    file_input = Enum.at(args, 0)
    {part_one, part_two} = {part_one_result(file_input), part_two_result(file_input)}
    IO.puts("Results is: #{part_one} and #{part_two}")
    {:ok, self()}
  end

  defp parse_to_list(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.split(&1))
    |> Stream.map(&Enum.map(&1, fn i -> String.to_integer(i) end))
    |> Enum.to_list()
  end

  defp is_asc?(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a < b end)
  end

  defp is_des?(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a > b end)
  end

  defp safe_report?(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> abs(a - b) in 1..3 and (is_asc?(report) or is_des?(report)) end)
  end

  defp can_be_safe?(report) do
    0..(length(report) - 1)
    |> Enum.any?(fn index ->
      modified_report = List.delete_at(report, index)
      safe_report?(modified_report)
    end)
  end

  defp count_safe_reports(reports, :saf) do
    reports
    |> Enum.count(fn report ->
      safe_report?(report)
    end)
  end

  defp count_safe_reports(reports, :war) do
    reports
    |> Enum.count(fn report ->
      safe_report?(report) or can_be_safe?(report)
    end)
  end

  def part_one_result(reports) do
    reports
    |> parse_to_list()
    |> count_safe_reports(:saf)
  end

  def part_two_result(reports) do
    reports
    |> parse_to_list()
    |> count_safe_reports(:war)
  end
end
