defmodule ExBanking.Repo do
  @moduledoc false

  use GenServer

  alias ExBanking.Repo

  @name __MODULE__

  def start_link(initial_user) do
    GenServer.start_link(@name, initial_user, name: @name)
  end

  @spec create_user(user :: String.t) :: :ok | ExBanking.banking_error
  def create_user(user) when is_bitstring(user) do
    if String.trim(user) != "" do
      GenServer.cast(@name, {:create_user, user})
    else
      {:error, :wrong_arguments}
    end
  end

  def create_user(_), do: {:error, :wrong_arguments}

  def get_data(user, repo_server \\ Repo)

  def get_data(user, repo_server) when is_bitstring(user) and is_atom(repo_server) do
    if String.trim(user) != "" do
      GenServer.call(@name, {:get_data, user, repo_server})
    else
      {:error, :wrong_arguments}
    end
  end

  def get_data(_,_), do: {:error, :wrong_arguments}

  @spec get_balance(user :: String.t, currency :: String.t) :: {:ok, balance :: number} | ExBanking.banking_error
  def get_balance(user, currency) when is_bitstring(user) and is_bitstring(currency) do
    GenServer.call(user, {:get_balance, currency})
  end

  def get_balance(_, _), do: {:error, :wrong_arguments}

  def deposit(_user, _amount, _currency) do
  end

  @impl true
  def init(initial_user), do: {:ok, initial_user}

  @impl true
  def handle_call({:get_data, user, repo_server}, _from, state) do
    result = %{
      user: user,
      amount: 0,
      currency: nil,
      server: repo_server
    }

    {:reply, result, state}
  end

  @impl true
  def handle_call({:get_balance, currency}, _from, state) do
    {:reply, {:ok, currency}, state}
  end

  @impl true
  def handle_cast({:create_user, new_user}, _state) do
    {:noreply, new_user}
  end
end
