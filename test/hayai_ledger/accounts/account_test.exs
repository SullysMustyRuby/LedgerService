defmodule HayaiLedger.Accounts.AccountTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Accounts.Account
  alias HayaiLedger.Repo

  describe "validations" do
  	test "returns error if no name" do
  		bad_name = Map.delete(valid_attrs(), :name)
  		changeset = Account.changeset(%Account{}, bad_name)
  		assert changeset.valid? == false
  		assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
  	end

  	test "returns error if no type" do
  		bad_type = Map.delete(valid_attrs(), :type_id)
  		changeset = Account.changeset(%Account{}, bad_type)
  		assert changeset.valid? == false
  		assert changeset.errors[:type_id] == {"can't be blank", [validation: :required]}
  	end

  	test "returns error if type does not exist" do
  		bad_type = Map.put(valid_attrs(), :type_id, 555)
  		changeset = Account.changeset(%Account{}, bad_type)
  		{result, account} = Repo.insert(changeset)
  		assert :error == result
  		assert account.valid? == false
  		assert account.errors[:type_id] == {"does not exist", [constraint: :foreign, constraint_name: "accounts_type_id_fkey"]}
  	end

  	test "returns an account when sucessful" do
  		changeset = Account.changeset(%Account{}, valid_attrs())
  		{result, _account} = Repo.insert(changeset)
  		assert result == :ok
  	end
  end

  defp valid_attrs() do
  	%{
  		description: "some description", 
  		name: "some name",
  		type_id: create_account_type().id
  	}
  end

  defp create_account_type() do
  	{:ok, type} = HayaiLedger.Accounts.create_account_type(%{ name: "cash" })
  	type
  end
end