defmodule ExBanking.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: true

    children = [
      {ExBanking, []},
      {Registry, keys: :unique, name: :user_process_registry},
      supervisor(ExBanking.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: ExBanking.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
