defmodule ExBankingTest do
  use ExUnit.Case
  doctest ExBanking

  test "create user in ex_banking" do
    user1 = "Oleg"

    assert ExBanking.create_user(user1) == :ok
    assert ExBanking.create_user(user1) == {:error, :user_already_exists}
    assert ExBanking.create_user(123) == {:error, :wrong_arguments}
    assert ExBanking.create_user(nil) == {:error, :wrong_arguments}
  end
end
