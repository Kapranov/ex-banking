defmodule ExBanking.Repo do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link(initial_user) do
    GenServer.start_link(@name, initial_user, name: @name)
  end

  @spec create_user(user :: String.t) :: :ok | ExBanking.banking_error
  def create_user(user) when is_bitstring(user) do
    GenServer.cast(@name, {:create_user, user})
  end

  def create_user(_), do: {:error, :wrong_arguments}

  @impl true
  def init(initial_user), do: {:ok, initial_user}

  @impl true
  def handle_cast({:create_user, new_user}, _state) do
    {:noreply, new_user}
  end
end
