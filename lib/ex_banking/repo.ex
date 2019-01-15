defmodule ExBanking.Repo do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link(initial_user) do
    GenServer.start_link(@name, initial_user, name: @name)
  end

  @impl true
  def init(initial_user), do: {:ok, initial_user}
end
