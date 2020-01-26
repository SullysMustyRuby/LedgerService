defmodule HayaiLedger.Ledgers.TransactionTest do
  use HayaiLedger.DataCase

   alias HayaiLedger.Ledgers.Transaction
   alias HayaiLedger.Repo

  @valid_attrs %{amount_currency: "some amount_currency", amount_subunits: 42, description: "some description", type: "some type", uid: "some uid"}
  @invalid_attrs %{amount_currency: nil, amount_subunits: nil, description: nil, type: nil, uid: nil}

  describe "validations" do
  	test "returns invalid with error if no account_id" do
  		changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)
  		assert false == changeset.valid?
  		assert changeset.errors[:account_id] == {"can't be blank", [validation: :required]}
  	end

  	test "returns invalid with error if the account does not exist" do
  		bad_account = Map.put(@valid_attrs, :account_id, 555)
  		changeset = Transaction.changeset(%Transaction{}, bad_account)
			{result, transaction} = Repo.insert(changeset)
			assert :error == result
			assert transaction.errors[:account_id] == {"does not exist",[constraint: :foreign, constraint_name: "transactions_account_id_fkey"]}
  	end

  	test "returns valid changeset when account exists" do
  		account = create_account()
  		good_account = Map.put(@valid_attrs, :account_id, account.id)
  		changeset = Transaction.changeset(%Transaction{}, good_account)
  		assert changeset.valid?
  		{result, _transaction} = Repo.insert(changeset)
  		assert :ok == result
  	end
  end

  defp create_account() do
    {:ok, account} = HayaiLedger.Accounts.create_account(%{
                        currency: "JPY",
                        name: "Yuko Cash",
                        type_id: create_account_type().id
                      })
    account
  end

  defp create_account_type() do
    {:ok, type} = HayaiLedger.Accounts.create_account_type(%{ name: "cash" })
    type
  end

end