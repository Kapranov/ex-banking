defmodule ExBankingRepoTest do
  use ExUnit.Case, async: false
  doctest ExBanking.Repo

  alias ExBanking.{Server, Repo}

  setup do
    count = 1..9
    names = for _ <- count, do: Faker.Name.first_name
    users = for user <- names, do: Repo.create_user(user)
    %{
      user: users,
      name: names,
      count: count
    }
  end

  test "create_user by ExBanking.Repo", %{user: _users, name: names, count: count} do
    users = for user <- names, do: Repo.create_user(user)
    exists = for _ <- count, do: {:error, :user_already_exists}

    assert users == exists
    assert Repo.create_user(123) == {:error, :wrong_arguments}
    assert Repo.create_user(nil) == {:error, :wrong_arguments}
  end

  test "get_balance show a balance of user by ExBanking.Server", %{user: _users, name: names, count: count} do
    balances = for user <- names, do: Server.get_balance(user)
    result = for _ <- count, do: {:ok, []}

    assert result == balances
  end

  test "deposit for user by ExBanking.Server", %{user: _users, name: names, count: count} do
    foods = for _ <- 1..1, do: Faker.Food.dish
    deposits = for user <- names, food <- foods, do: Server.deposit(user, food)
    result = for _ <- count, do: :ok

    assert deposits == result
  end

  test "find_or_create_user by ExBanking.Repo" do
    name = Faker.Name.first_name

    assert Repo.find_or_create_user(name) == :ok
    assert Repo.create_user(name) == {:error, :user_already_exists}
    assert Repo.create_user(123) == {:error, :wrong_arguments}
    assert Repo.create_user(nil) == {:error, :wrong_arguments}
  end

  test "destroy_user by ExBanking.Repo" do
    name = Faker.Name.first_name

    assert Repo.create_user(name) == :ok
    assert Repo.create_user(name) == {:error, :user_already_exists}
    assert Repo.destroy_user(name) == :ok
  end

  test "check user exist by ExBanking.Repo", %{user: _users, name: names, count: count} do
    registred = for user <- names, do: Repo.user_exists?(user)
    result = for _ <- count, do: true

    assert registred == result
  end

  test "count all users have been registered" do
    %{active: nums, specs: _, supervisors: _, workers: _} = Supervisor.count_children(:user_supervisor)

    assert Repo.get_count == nums
  end

  test "register_name", %{user: _users, name: names, count: count} do
    registred = for user <- names, do: Repo.register_name(user)
    result = for _ <- count, do: true

    assert registred == result
  end

  test "Check an alive Register process by ExBanking.Server" do
    registry = Process.whereis(:user_process_registry)

    assert Process.alive?(registry) == true
  end

  test "a new child process will restart as needed" do
    user = "Aloha"

    [{_, pid, _, _}] = Supervisor.which_children(:user_process_registry)

    assert Repo.create_user(user) === :ok

    GenServer.stop(pid, :normal)

    [{_, new_pid, _, _}] = Supervisor.which_children(:user_process_registry)

    assert new_pid !== pid

    assert Repo.create_user(user) === :ok
  end

  test "check dead of process", %{user: _users, name: names, count: _count} do
    user = names |> List.first
    [{pid1, _}] = Registry.lookup(:user_process_registry, user)

    Process.exit(pid1, :kill)
    ref = Process.monitor(pid1)

    assert_receive {:DOWN, ^ref, _, _, _}
  end
end
