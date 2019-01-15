defmodule ExBanking.Application do
  @moduledoc false

  use Application

  alias ExBanking.Repo

  def start(_type, _args) do
    children = [
      {Repo, 0},
      {ExBanking, Repo}
    ]

    opts = [strategy: :one_for_one, name: ExBanking.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
