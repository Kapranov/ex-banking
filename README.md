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

iex> ExBanking.Registry.whereis_name({:init_user, "Oleg"}) |> Process.exit(:kill)
iex> ExBanking.Server.get_balance("Oleg")
iex> ExBanking.Server.deposit("Oleg", "Aloha kakahiaka")
iex> ExBanking.Server.get_balance("Oleg")

iex> ExBanking.Registry.whereis_name({:init_user, "Josh"}) |> Process.exit(:kill)
iex> ExBanking.Server.get_balance("Josh")
iex> ExBanking.Server.deposit("Josh", "Aloha awakea")
iex> ExBanking.Server.get_balance("Josh")

iex> ExBanking.Registry.whereis_name({:init_user, "John"}) |> Process.exit(:kill)
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

### 15 Jan 2019
