defmodule ExBanking.Server do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link(name) do
    GenServer.start_link(@name, [], name: via_tuple(name))
  end

  def get_balance(room_name) do
    GenServer.call(via_tuple(room_name), :get_balance)
  end

  def deposit(room_name, name) do
    GenServer.cast(via_tuple(room_name), {:deposit, name})
  end

  def init(_), do: {:ok, %{}}

  def handle_call(:get_balance, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:deposit, name}, _state) do
    {:noreply, name}
  end

  defp via_tuple(room_name) do
    {:via, ExBanking.Registry, {@name, room_name}}
  end
end
