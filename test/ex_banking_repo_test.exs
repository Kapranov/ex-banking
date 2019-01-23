defmodule ExBankingRepoTest do
  use ExUnit.Case, async: true
  doctest ExBanking.Repo

  setup do
    user = Faker.Name.first_name
    %{user: user}
  end

  test "create user by ExBanking.Repo", %{user: user} do
    assert ExBanking.Repo.create_user(user) == :ok
    assert ExBanking.Repo.create_user(user) == {:error, :user_already_exists}
    assert ExBanking.Repo.create_user(123) == {:error, :wrong_arguments}
    assert ExBanking.Repo.create_user(nil) == {:error, :wrong_arguments}
  end

  test "show get_balance and deposit by ExBanking.Server", %{user: user} do
    assert ExBanking.Repo.create_user(user) == :ok
    assert ExBanking.Server.deposit(user, "Aloha") == :ok
    assert ExBanking.Server.get_balance(user) == {:ok, ["Aloha"]}
  end

  test "find_or_create_user by ExBanking.Repo",  %{user: user} do
    assert ExBanking.Repo.find_or_create_user(user) == :ok
    assert ExBanking.Repo.create_user(user) == {:error, :user_already_exists}
  end

  test "destroy_user by ExBanking.Repo", %{user: user} do
    assert ExBanking.Repo.create_user(user) == :ok
    assert ExBanking.Repo.create_user(user) == {:error, :user_already_exists}
    assert ExBanking.Repo.destroy_user(user) == :ok
  end

  test "check user exist by ExBanking.Repo", %{user: user} do
    assert ExBanking.Repo.create_user(user) == :ok
    assert ExBanking.Repo.create_user(user) == {:error, :user_already_exists}
    assert ExBanking.Repo.user_exists?(user)  == true
  end

  test "show all users by ExBanking.Repo" do
    # assert  ExBanking.Repo.get_users == []
  end

  test "show count all users have been registered" do
    # assert ExBanking.Repo.get_count ==
  end

  test "check dead of process", %{user: user} do
    assert ExBanking.Repo.create_user(user) == :ok
    assert ExBanking.Server.get_balance(user) == {:ok, []}
    assert ExBanking.Server.deposit(user, "Aloha kakahiaka") == :ok
    assert ExBanking.Server.get_balance(user) == {:ok, ["Aloha kakahiaka"]}

    [{pid1, _}] = Registry.lookup(:user_process_registry, user)

    Process.exit(pid1, :kill)
    ref = Process.monitor(pid1)

    assert_receive {:DOWN, ^ref, _, _, _}
  end

  test "a new child process will restart as needed", %{user: user} do
    [{_, pid, _, _}] = Supervisor.which_children(:user_process_registry)

    assert ExBanking.Repo.create_user(user) === :ok
    GenServer.stop(pid, :normal)

    [{_, new_pid, _, _}] = Supervisor.which_children(:user_process_registry)
    assert new_pid !== pid

    assert ExBanking.Repo.create_user(user) === :ok
  end

  test "Check an alive Register process by ExBanking.Server" do
    registry = Process.whereis(:user_process_registry)

    assert Process.alive?(registry) == true
  end

  test "Registry new process by ExBanking.Server", %{user: user} do
    assert ExBanking.Repo.create_user(user) == :ok
    assert ExBanking.Repo.create_user(user) == {:error, :user_already_exists}
    assert ExBanking.Repo.register_name(user) == true
  end
end

