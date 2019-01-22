# ExBanking

**TODO: Add description**

## There are rules if you will use a module `ExBanking.Registry`:

The file `lib/ex_banking/server.ex`:

```elixir
defmodule ExBanking.Server do
  @moduledoc false

  # ...

  defp via_tuple(name) do
    {:via, ExBanking.Registry, {:init_user, name}}
  end

  # ...
end
```

```bash
iex> {:ok, pid1} = ExBanking.Repo.create_user("Oleg")
iex> {:ok, pid2} = ExBanking.Repo.create_user("Josh")
iex> {:ok, pid3} = ExBanking.Repo.create_user("John")

iex> ExBanking.Registry.whereis_name("Oleg")
iex> ExBanking.Registry.whereis_name("Josh")
iex> ExBanking.Registry.whereis_name("John")

iex> ExBanking.Registry.register_name("Oleg", pid1)
iex> ExBanking.Registry.register_name("Josh", pid2)
iex> ExBanking.Registry.register_name("John", pid3)

iex> ExBanking.Registry.whereis_name("Oleg")
iex> ExBanking.Registry.whereis_name("Josh")
iex> ExBanking.Registry.whereis_name("John")

iex> ExBanking.Registry.unregister_name("Oleg")
iex> ExBanking.Registry.unregister_name("Josh")
iex> ExBanking.Registry.unregister_name("John")

iex> ExBanking.Registry.whereis_name("Oleg")
iex> ExBanking.Registry.whereis_name("Josh")
iex> ExBanking.Registry.whereis_name("John")

iex> Process.exit(Process.whereis(:user_supervisor), :kill)

iex> ExBanking.Repo.create_user("Oleg")
iex> ExBanking.Repo.create_user("Josh")
iex> ExBanking.Repo.create_user("John")

iex> ExBanking.Server.deposit("Oleg", "Aloha")
iex> ExBanking.Server.deposit("Josh", "Mahalo")
iex> ExBanking.Server.deposit("John", "Lū‘au")

iex> ExBanking.Server.get_balance("Oleg")
iex> ExBanking.Server.get_balance("Josh")
iex> ExBanking.Server.get_balance("John")

iex> Process.whereis(:user_process_registry)

iex> ExBanking.Registry.whereis_name({:user_process_registry, "Oleg"}) |> Process.exit(:kill)

iex> ExBanking.Server.get_balance("Oleg")
iex> ExBanking.Server.deposit("Oleg", "Aloha kakahiaka")
iex> ExBanking.Server.get_balance("Oleg")

iex> ExBanking.Registry.whereis_name({:user_process_registry, "Josh"}) |> Process.exit(:kill)

iex> ExBanking.Server.get_balance("Josh")
iex> ExBanking.Server.deposit("Josh", "Aloha awakea")
iex> ExBanking.Server.get_balance("Josh")

iex> ExBanking.Registry.whereis_name({:user_process_registry, "John"}) |> Process.exit(:kill)

iex> ExBanking.Server.get_balance("John")
iex> ExBanking.Server.deposit("John", "Aloha ‘auinalā")
iex> ExBanking.Server.get_balance("John")
```

## There are rules if you will use en extand the package `gproc`:

```elixir
defmodule ExBanking.Server do
  @moduledoc false

  use GenServer

  @name __MODULE__
  @user_registry :user_process_registry

  # ...

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {@user_registry, name}}}
  end

  # ...
end
```

```elixir
defmodule ExBanking.MixProject do
  use Mix.Project

  # ...

  def application do
    [
      extra_applications: applications(Mix.env),
      mod: {ExBanking.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_unit_notifier, "~> 0.1.4", only: :test},
      {:gproc, "~> 0.8.0"},
      {:mix_test_watch, "~> 0.9.0"},
      {:remix, "~> 0.0.2", only: :dev}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger, :gproc]
end
```

```bash
iex> ExBanking.Repo.create_user("Oleg")
iex> ExBanking.Repo.create_user("Josh")
iex> ExBanking.Repo.create_user("John")

iex> ExBanking.Server.deposit("Oleg", "Aloha")
iex> ExBanking.Server.deposit("Josh", "Mahalo")
iex> ExBanking.Server.deposit("John", "Lū‘au")

iex> ExBanking.Server.get_balance("Oleg")
iex> ExBanking.Server.get_balance("Josh")
iex> ExBanking.Server.get_balance("John")

iex> Process.whereis(:user_process_registry)

iex> :gproc.where({:n, :l, {:user_process_registry, "Oleg"}}) |> Process.exit(:kill)

iex> ExBanking.Server.get_balance("Oleg")
iex> ExBanking.Server.deposit("Oleg", "Aloha kakahiaka")
iex> ExBanking.Server.get_balance("Oleg")

iex> :gproc.where({:n, :l, {:user_process_registry, "Josh"}}) |> Process.exit(:kill)

iex> ExBanking.Server.get_balance("Josh")
iex> ExBanking.Server.deposit("Josh", "Aloha awakea")
iex> ExBanking.Server.get_balance("Josh")

iex> :gproc.where({:n, :l, {:user_process_registry, "John"}}) |> Process.exit(:kill)

iex> ExBanking.Server.get_balance("John")
iex> ExBanking.Server.deposit("John", "Aloha ‘auinalā")
iex> ExBanking.Server.get_balance("John")
```

## There are rules if you will use a module `Kernel.Registry`:

The file `lib/ex_banking/server.ex`:

```elixir
defmodule ExBanking.Server do
  @moduledoc false

  use GenServer

  @name __MODULE__
  @user_registry :user_process_registry

  # ...

  defp via_tuple(name) do
    {:via, Registry, {@user_registry, name}}
  end

  # ...
end
```

```bash
iex> ExBanking.Repo.create_user("Oleg")
iex> ExBanking.Repo.create_user("Josh")
iex> ExBanking.Repo.create_user("John")

iex> ExBanking.Server.deposit("Oleg", "Aloha")
iex> ExBanking.Server.deposit("Josh", "Mahalo")
iex> ExBanking.Server.deposit("John", "Lū‘au")

iex> ExBanking.Server.get_balance("Oleg")
iex> ExBanking.Server.get_balance("Josh")
iex> ExBanking.Server.get_balance("John")

iex> Process.whereis(:user_process_registry)

iex> [{pid1, _}] = Registry.lookup(:user_process_registry, "Oleg")
iex> [{pid2, _}] = Registry.lookup(:user_process_registry, "Josh")
iex> [{pid3, _}] = Registry.lookup(:user_process_registry, "John")

iex> Process.exit(pid1, :kill)

iex> ExBanking.Server.get_balance("Oleg")
iex> ExBanking.Server.deposit("Oleg", "Aloha kakahiaka")
iex> ExBanking.Server.get_balance("Oleg")

iex> Process.exit(pid2, :kill)

iex> ExBanking.Server.get_balance("Josh")
iex> ExBanking.Server.deposit("Josh", "Aloha awakea")
iex> ExBanking.Server.get_balance("Josh")

iex> Process.exit(pid3, :kill)

iex> ExBanking.Server.get_balance("John")
iex> ExBanking.Server.deposit("John", "Aloha ‘auinalā")
iex> ExBanking.Server.get_balance("John")
```

## The functions in `ExBanking.Repo`

```bash
iex> Supervisor.which_children(:user_process_registry)

iex> ExBanking.Repo.create_user("Oleg")
iex> ExBanking.Repo.find_or_create_user("Josh")
iex> ExBanking.Repo.destroy_user("Josh")
iex> ExBanking.Repo.user_exists?("Josh")
iex> ExBanking.Repo.get_users
iex> ExBanking.Repo.user_process_count

iex> [{pid, _}] = Registry.lookup(:user_process_registry, "Oleg")
iex> Process.register(pid, :oleg)
```

### 15 Jan 2019 by Oleg G.Kapranov
