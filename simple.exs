defmodule Fraction do
  defstruct a: nil, b: nil
  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  def value(%Fraction{a: a, b: b}) do
    a / b
  end
end
defmodule Examples do
  def list_of_employees() do
    employees = ['alice', 'bob', 'john']
    employees 
    |> 
      Stream.with_index 
    |> 
      Enum.each(fn({employee, index}) ->
      IO.puts "#{index + 1}. #{employee}" 
    end)
  end
  def list_of_employees_stream() do
    stream = [1, 2, 3]
    |> Stream.map(fn(x) -> 
      x * 2 end)
    Enum.to_list(stream)
    Enum.take(stream, 2)
  end
  defp filtered_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def large_lines!(path) do
    filtered_lines!(path)
    |> Enum.filter(&(String.lenght(&1) > 80))
  end
  def lines_length!(path) do
    filtered_lines!(path)
    |> Enum.each(&(IO.puts "#{String.length(&1)}"))
  end

  def longest_line_length!(path) do
    filtered_lines!(path)
    |> Stream.map(&(String.length(&1)))
    |> Enum.sort(&(&1 > &2))
    |> hd
  end

  def longest_line!(path) do
    filtered_lines!(path)
    |> Stream.map(&{&1, String.length(&1)})
    |> Enum.sort(fn({_, x}, {_, y}) -> x > y end)
    |> hd
    |> elem(0)
  end

def sqr_nbr() do
    [9, -1, 2, 'es', 432, 32]
    |>
      Stream.filter(&(is_number(&1) and &1 > 0))
    |>
      Stream.map(&{&1, :math.sqrt(&1)})
    |>
      Stream.with_index
    |>
      Enum.each(fn({{input, result}, index}) ->
        IO.puts "#{index + 1}. sqrt(#{input}) = #{result}"
      end)
  end
end
defmodule FileTut do

  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 80))
  end
  def lines_length!(path) do
    File.stream!(path)
    |> Enum.each(&IO.puts/1)
  end
end
defmodule Recursion do
  def count(1), do: IO.puts(1)
  def count(n) do
    IO.puts(n)
    count(n - 1)
  end
end
defmodule Fact do
  def fact(0), do: 1
  def fact(n), do: n * fact(n - 1)
end
defmodule Geo do
    def area(a, b), do: a * b

    def write_multi(msg, n) when n <= 1 do
        IO.puts(msg)
    end
    def write_multi(msg, n) do
        IO.puts(msg)
        write_multi(msg, n - 1)
    end

    def sum_list([head | tail], accumulator) do
        sum_list(tail, head + accumulator)
    end

    def sum_list([], accumulator) do
        IO.puts(accumulator)
    end
end

defmodule Rectangle do
    def area({a, b}) do
        a * b
    end
end

Geo.sum_list([1, 2, 3], 4)

defmodule G do
    def test(a, b) do
        Geo.area(a, b)
    end
end

defmodule Test do
    import IO

    def write(text) do
        puts(text)
    end
end
