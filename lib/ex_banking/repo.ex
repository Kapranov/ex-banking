defmodule ExBanking.Repo do
  @moduledoc """
  Supervisor to handle the creation of dynamic `ExBanking.Server` processes using a
  `simple_one_for_one` strategy. See the `init` callback at the bottom for details on that.
  """

  use Supervisor

  @name __MODULE__
  @name_supervisor :user_supervisor
  @user_registry :user_process_registry

  @doc """
  Starts the supervisor.
  """
  def start_link do
    Supervisor.start_link(@name, [], name: @name_supervisor)
  end

  @doc """
  Creates a new user process, based on the `name` string.

  Returns a tuple such as `{:ok, name}` if successful.
  If there is an issue, an `{:error, reason}` tuple is returned.
  """
  def create_user(name) when is_bitstring(name) do
    case Supervisor.start_child(@name_supervisor, [name]) do
      {:ok, _} -> :ok
      {:error, {:already_started, _}} -> {:error, :user_already_exists}
    end
  end

  def create_user(name)
      when is_integer(name)
      when is_float(name)
      when is_binary(name)
      when is_nil(name) do
    {:error, :wrong_arguments}
  end

  @doc """
  Convert user process to atom by `ExBanking.Server`.

  Return boolean `true` if successful.
  If there is an issue, a `false` is returned.
  """
  @spec register_name(name :: String.t) :: :atom | false
  def register_name(name) when is_bitstring(name) do
    case Registry.lookup(@user_registry, name) do
      [] -> false
      [{pid, _}] -> convert(pid, name)
    end
  end

  @doc """
  Determines if a `ExBanking.Server` process exists, based on the `name` provided.

  Returns a boolean.
  """
  def user_exists?(name) when is_bitstring(name) do
    case Registry.lookup(@user_registry, name) do
      [] -> false
      _ -> true
    end
  end

  @doc """
  Will find the process identifier (in our case, the `name`) if it exists in the registry and
  is attached to a running `ExBanking.Server` process.

  If the `name` is not present in the registry, it will create a new `ExBanking.Server`
  process and add it to the registry for the given `name`.

  Returns a tuple such as `{:ok, name}` or `{:error, reason}`
  """
  def find_or_create_user(name) when is_bitstring(name) do
    if user_exists?(name) do
      {:ok, name}
    else
      name |> create_user()
    end
  end

  @doc """
  Delete user's process, based on the `name` string.

  Returns a tuple such a `{:ok}` or `{:error, reason}`
  """
  def destroy_user(name) when is_bitstring(name) do
    case Registry.lookup(@user_registry, name) do
      [] -> :ok
      [{pid, _}] ->
        Process.exit(pid, :shutdown)
        :ok
    end
  end

  @doc """
  Return a list of `name` strings known by the registry.
  """
  def get_users do
    Supervisor.which_children(@name_supervisor)
    |> Enum.map(fn {_, name, _, _} ->
      Registry.keys(@user_registry, name)
      |> List.first
    end)
    |> Enum.sort
  end

  @doc """
  Returns the count of `ExBanking.Server` processes managed by this supervisor.
  """
  def get_count, do: Supervisor.which_children(@name_supervisor) |> length

  @doc false
  @impl true
  def init(_) do
    # without custom ExBanking.Registry
    # ExBanking.Registry.start_link

    children = [
      worker(ExBanking.Server, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  @doc false
  defp convert(pid, name) do
    state =
      name
      |> String.downcase
      |> String.to_atom

    Process.register(pid, state)
  end
end
