defmodule Todo.List.CsvImporter do
  defp read_lines(file) do
    file
    |> File.stream!
    |> Stream.map(fn(x) -> String.replace(x, "\n", "") end)
  end

  defp create_entry(line) do
    entry = line
    |> Stream.map(fn(x) ->
      [date, title] = String.split(x, ",")
    end)
    |> Enum.map(fn(line) -> convert(line) end)
    Todo.List.new(entry)
  end

  defp convert([date, title]) do
    date = String.split(date, "/")
    [year, month, day] = Enum.map(date, fn(date) -> String.to_integer(date) end)
    %{date: {year, month, day}, title: title}
  end


  def import!(path) do
    path
    |> read_lines
    |> create_entry
  end
end

defmodule Processing do
  def query(q) do
    :timer.sleep(2000)
    "#{q} result"
  end
end

defmodule Todo.List do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %Todo.List{},
      fn(entry, todo_list_acc) ->
        add_entry(todo_list_acc, entry)
      end
    )
  end

  def add_entry(%Todo.List{auto_id: auto_id, entries: entries} = todo_list, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put_new(entries, auto_id, entry)
    %Todo.List{todo_list | 
      entries: new_entries,
      auto_id: auto_id + 1
    }
  end

  def entries(%Todo.List{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, entry}) ->
      entry.date == date
    end)
    |> Enum.map(fn({_, entry}) ->
      entry
    end)
  end

  def update_entry(%Todo.List{entries: entries} = todo_list, entry_id, updater_fun) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  def delete_entry(%Todo.List{entries: entries} = todo_list, entry_id) do
    todo_list = Map.delete(entries, entry_id)
  end
end


