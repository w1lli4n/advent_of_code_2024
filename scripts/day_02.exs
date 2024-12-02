defmodule Day2 do
  def parse_to_list(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.split(&1))
    |> Stream.map(&Enum.map(&1, fn i -> String.to_integer(i) end))
    |> Enum.to_list()
  end

  def safe_report?(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> abs(a - b) in 1..3 and (is_asc?(report) or is_des?(report)) end)
  end

  def is_asc?(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a < b end)
  end

  def is_des?(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a > b end)
  end

  def can_be_safe?(report) do
    0..(length(report) - 1)
    |> Enum.any?(fn index ->
      modified_report = List.delete_at(report, index)
      safe_report?(modified_report)
    end)
  end

  def count_safe_reports(reports, :saf) do
    reports
    |> Enum.count(fn report ->
      safe_report?(report)
    end)
  end

  def count_safe_reports(reports, :war) do
    reports
    |> Enum.count(fn report ->
      safe_report?(report) or can_be_safe?(report)
    end)
  end

  def show() do
    reports =
      "../day_02/assets/input"
      # "assets/test_input_02"
      # "assets/test_input_02_edge"
      |> parse_to_list()

    result_one = reports |> count_safe_reports(:saf)
    result_two = reports |> count_safe_reports(:war)

    {result_one, result_two}
  end
end

IO.inspect(Day2.show())
