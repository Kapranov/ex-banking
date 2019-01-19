defmodule ExBanking.Registry do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link(_), do: GenServer.start_link(@name, nil, name: :registry)

  def whereis_user(name) do
    GenServer.call(:registry, {:whereis_user, name})
  end

  def register_user(name, pid) do
    GenServer.call(:registry, {:register_user, name, pid})
  end

  def unregister_user(name) do
    GenServer.cast(:registry, {:unregister_user, name})
  end

  def send(name, message) do
    case whereis_user(name) do
      :undefined ->
        {:badarg, {name, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  def init(_), do: {:ok, Map.new}

  def handle_call({:whereis_user, name}, _from, state) do
    {:reply, Map.get(state, name, :undefined), state}
  end

  def handle_call({:register_user, name, pid}, _from, state) do
    case Map.get(state, name) do
      nil ->
        {:reply, :yes, Map.put(state, name, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_user, name}, state) do
    {:noreply, Map.delete(state, name)}
  end
end
