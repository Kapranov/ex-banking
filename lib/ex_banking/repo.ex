defmodule ExBanking.Repo do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link(opts), do: GenServer.start_link(@name, opts, name: @name)

  @impl true
  def init(args), do: {:ok, args}
end
