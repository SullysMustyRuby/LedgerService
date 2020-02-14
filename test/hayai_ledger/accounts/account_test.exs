defmodule HayaiLedger.Accounts.AccountTest do
  use HayaiLedger.DataCase

  import Support.Fixtures.AccountFixtures

  alias HayaiLedger.Accounts.Account
  alias HayaiLedger.Repo

  describe "validations" do
  	test "returns error if no currency" do
  		bad_name = Map.delete(account_attrs(), :currency)
  		changeset = Account.changeset(%Account{}, bad_name)
  		assert changeset.valid? == false
  		assert changeset.errors[:currency] == {"can't be blank", [validation: :required]}
  	end

    test "returns error if no kind" do
      bad_kind = Map.delete(account_attrs(), :kind)
      changeset = Account.changeset(%Account{}, bad_kind)
      assert changeset.valid? == false
      assert changeset.errors[:kind] == {"can't be blank", [validation: :required]}
    end

    test "returns error if kind is not asset, equity, or liability" do
      bad_kind = Map.put(account_attrs(), :kind, "nonono")
      changeset = Account.changeset(%Account{}, bad_kind)
      assert changeset.valid? == false
      assert changeset.errors[:kind] == {"is invalid", [{:validation, :inclusion}, {:enum, ["asset", "equity", "liability"]}]}
    end

  	test "returns error if no name" do
  		bad_name = Map.delete(account_attrs(), :name)
  		changeset = Account.changeset(%Account{}, bad_name)
  		assert changeset.valid? == false
  		assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
  	end

  	test "returns an account when sucessful" do
  		changeset = Account.changeset(%Account{}, account_attrs())
  		{result, _account} = Repo.insert(changeset)
  		assert result == :ok
  	end
  end
end