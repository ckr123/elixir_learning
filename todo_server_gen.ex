defmodule TodoServer do
  use GenServer

  def start do
    GenServer.start(TodoServer, nil)
  end

  def init(_) do
    {:ok, Todolist.new}
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    new_state = Todolist.add_entry(todo_list, new_entry)
    {:noreply, new_state}
  end

  def handle_call({:entries, date}, _, state) do
    {:reply, Todolist.entries(state, date), state}
  end
end

defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn(entry, todo_list_acc) ->
        add_entry(todo_list_acc, entry)
      end
    )
  end

  def add_entry(%TodoList{entries: entries, auto_id: auto_id} = todo_list, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put_new(entries, auto_id, entry)
    %TodoList{todo_list | 
      entries: new_entries,
      auto_id: auto_id + 1
    }
  end

  def entries(%TodoList{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, entry}) ->
      entry.date == date
    end)
    |> Enum.map(fn({_, entry}) ->
      entry
    end)
  end

  def update_entry(%TodoList{entries: entries} = todo_list, entry_id, updater_fun) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(%TodoList{entries: entries} = todo_list, entry_id) do
    todo_list = Map.delete(entries, entry_id)
  end
end