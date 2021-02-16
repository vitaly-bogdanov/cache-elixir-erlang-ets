defmodule CacheDbTest.Cache do
  use GenServer
  import Enum, only: [each: 2]

  @moduledoc "
    Модуль для кеширования результвтов базы данных
  "

  @table_names [:users]

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: CampCache)
  end
  def init(state) do
    each @table_names, fn table_name ->
      :ets.new(table_name, [:set, :public, :named_table])
    end
    {:ok, state}
  end

  @doc "
    iex> CacheDbTest.Cache.get(some_id)
    Получаем одну запись из ETS по переданному id
  "
  def get(table, key) do
    GenServer.call(CampCache, {:get, table, key})
  end

  @doc "
    iex> CacheDbTest.Cache.put(some_id, data)
    Создаем запись в ETS
  "
  def put(table, data) do
    GenServer.cast(CampCache, {:put, table, data})
  end

  @doc "
    iex> CacheDbTest.Cache.delete(some_id)
    Удаляем запись из ETS
  "
  def delete(table, key) do
    GenServer.cast(CampCache, {:delete, table, key})
  end

  @doc "
    iex> CacheDbTest.Cache.get_all
    Получаем все записи
  "
  def get_all(table) when is_atom(table) do
    GenServer.call(CampCache, {:get_all, table})
  end

  def handle_cast({:delete, table, key}, state) when is_atom(key) and is_atom(table) do
    :ets.delete(table, key)
    {:noreply, state}
  end
  def handle_cast({:put, table, data}, state) do
    :ets.insert(table, {data.id, data})
    {:noreply, state}
  end

  def handle_call({:get, table, key}, _from, state) when is_atom(key) and is_atom(table) do
    reply = case :ets.lookup(table, key) do
      [] -> nil
      [{_key, item}] -> item
    end
    {:reply, reply, state}
  end
  def handle_call({:get_all, table}, _from, state) when is_atom(table) do
    reply = :ets.tab2list(table)
    {:reply, reply, state}
  end
end
