defmodule ExBanking.Repo do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link(initial_user) do
    GenServer.start_link(@name, initial_user, name: @name)
  end

  @doc false
  def create_user(user) do
    GenServer.cast(@name, {:create_user, user})
  end

  @impl true
  def init(initial_user), do: {:ok, initial_user}

  @impl true
  def handle_cast({:create_user, new_user}, _state) do
    {:noreply, new_user}
  end
end
