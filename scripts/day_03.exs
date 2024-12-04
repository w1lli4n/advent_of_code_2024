defmodule Day03 do
  def parse_file(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def filter_instructions(memory) do
    memory
    |> Enum.map(
      &Regex.scan(~r/mul\([0-9][0-9]?[0-9]?\,[0-9][0-9]?[0-9]?\)|do\(\)|don\'t\(\)/, &1)
    )
    |> normalize_list()
  end

  def filter_operands(instructions) do
    normalized_instructions = normalize_instructions(instructions)

    final_instructions =
      Regex.replace(~r/don't\(\).*?do\(\)|don't\(\).*/, normalized_instructions, "")

    Regex.scan(~r/[0-9][0-9]?[0-9]?/, final_instructions)
    |> Enum.map(fn [a] -> a end)
    |> Enum.map(fn a -> String.to_integer(a) end)
  end

  def execute_mul_instruction(instructions) do
    instructions
    |> filter_operands()
    |> Enum.chunk_every(2, 2, :discard)
    |> Enum.map(fn [a, b] -> a * b end)
  end

  def summ_products(products) do
    products
    |> Enum.reduce(0, fn a, acc -> a + acc end)
  end

  def normalize_list(list) do
    list
    |> Enum.concat()
    |> Enum.map(fn [a] -> a end)
  end

  def normalize_instructions(list) do
    list
    |> Enum.reduce("", fn a, acc -> acc <> a end)
  end

  def result() do
    "../day_03/assets/input"
    |> parse_file()
    |> filter_instructions()
    |> execute_mul_instruction()
    |> summ_products()

    # 161
    # 48
  end

  def inspect() do
    result()
    |> IO.inspect()
  end

  def show() do
    IO.puts("The result is: #{result()}")
  end
end

Day03.inspect()
