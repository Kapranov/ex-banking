defmodule ExBanking.Repo do
  @moduledoc false

  use Supervisor

  @name __MODULE__

  def start_link do
    Supervisor.start_link(@name, [], name: :user_supervisor)
  end

  def create_user(name) do
    Supervisor.start_child(:user_supervisor, [name])
  end

  def init(_) do
    ExBanking.Registry.start_link

    children = [
      worker(ExBanking.Server, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
