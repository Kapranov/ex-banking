defmodule ExBankingTest do
  use ExUnit.Case, async: true
  doctest ExBanking

  setup do
    user = Faker.Name.first_name
    %{user: user}
  end

  test "create user by ExBanking", %{user: user} do
    assert ExBanking.create_user(user) == :ok
    assert ExBanking.create_user(user) == {:error, :user_already_exists}
    assert ExBanking.create_user(123) == {:error, :wrong_arguments}
    assert ExBanking.create_user(nil) == {:error, :wrong_arguments}
  end
end
