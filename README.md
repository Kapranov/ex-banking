# ExBanking

**TODO: Add description**

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
iex> ExBanking.Server.deposit("Josh", "Aloha ‘auinalā")
iex> ExBanking.Server.get_balance("John")
```

### 15 Jan 2019
