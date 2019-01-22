defmodule ExBanking.Server do
  @moduledoc false

  use GenServer

  @name __MODULE__
  @user_registry :user_process_registry

  def start_link(name) do
    GenServer.start_link(@name, [], name: via_tuple(name))
  end

  def get_balance(user) do
    GenServer.call(via_tuple(user), :get_balance)
  end

  def deposit(user, account) do
    GenServer.cast(via_tuple(user), {:deposit, account})
  end

  # def init(_), do: {:ok, %{}}
  def init(_), do: {:ok, []}

  def handle_call(:get_balance, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:deposit, account}, state) do
    {:noreply, [account | state]}
  end

  # without custom ExBanking.Registry
  # defp via_tuple(name), do: {:via, ExBanking.Registry, {:init_user, name}}

  defp via_tuple(name), do: {:via, Registry, {@user_registry, name}}
end
