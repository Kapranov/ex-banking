defmodule ExBanking.Registry do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link, do: GenServer.start_link(@name, nil, name: :registry)

  def whereis_name(init_name) do
    GenServer.call(:registry, {:whereis_name, init_name})
  end

  def register_name(init_name, pid) do
    GenServer.call(:registry, {:register_name, init_name, pid})
  end

  def unregister_name(init_name) do
    GenServer.cast(:registry, {:unregister_name, init_name})
  end

  def send(init_name, message) do
    case whereis_name(init_name) do
      :undefined ->
        {:badarg, {init_name, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  def init(_), do: {:ok, Map.new}

  def handle_call({:whereis_name, init_name}, _from, state) do
    {:reply, Map.get(state, init_name, :undefined), state}
  end

  def handle_call({:register_name, init_name, pid}, _from, state) do
    case Map.get(state, init_name) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(state, init_name, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_name, init_name}, state) do
    {:noreply, Map.delete(state, init_name)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    {:noreply, remove_pid(state, pid)}
  end

  def remove_pid(state, pid_to_remove) do
    remove = fn {_key, pid} -> pid  != pid_to_remove end
    Enum.filter(state, remove) |> Enum.into(%{})
  end
end
