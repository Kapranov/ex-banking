defmodule ExBankingTest do
  use ExUnit.Case, async: false
  doctest ExBanking

  setup do
    count = 1..9
    names = for _ <- count, do: Faker.Name.first_name
    users = for user <- names, do: ExBanking.create_user(user)
    %{
      user: users,
      name: names,
      count: count
    }
  end

  test "create_user by ExBanking", %{user: _users, name: names, count: count} do
    users = for user <- names, do: ExBanking.create_user(user)
    exists = for _ <- count, do: {:error, :user_already_exists}

    assert users == exists
    assert ExBanking.create_user(123) == {:error, :wrong_arguments}
    assert ExBanking.create_user(nil) == {:error, :wrong_arguments}
  end
end
