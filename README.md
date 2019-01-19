# ExBanking

**TODO: Add description**

```bash
bash> mkdir ex-banking; cd ex-banking
bash> mix new ./ --app ex_banking --sup
```

```bash
iex> :observer.start
```

```bash
iex> {:ok, pid} = ExBanking.Repo.create_user("Oleg")
iex> ExBanking.Registry.whereis_user("Oleg")
iex> ExBanking.Registry.register_user("Oleg", pid)
iex> ExBanking.Registry.register_user("Oleg", pid)
iex> ExBanking.Registry.whereis_user("Oleg")
iex> ExBanking.Registry.unregister_user("Oleg")
iex> ExBanking.Registry.whereis_user("Oleg")
```

### 15 Jan 2019
