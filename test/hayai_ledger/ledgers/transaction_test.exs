defmodule HayaiLedger.Ledgers.TransactionTest do
  use HayaiLedger.DataCase

   alias HayaiLedger.Ledgers.Transaction
   alias HayaiLedger.Repo


  describe "validations" do
    setup do
      account = create_account()
      %{
        account: account,
        valid_attrs: %{ account_uid: account.uid, amount_currency: "JPY", amount_subunits: 42, kind: "credit" }
      }
    end

  	test "returns invalid with error if no account_id", %{ valid_attrs: valid_attrs } do
      no_account = Map.delete(valid_attrs, :account_uid)
  		changeset = Transaction.changeset(%Transaction{}, no_account)
  		assert false == changeset.valid?
  		assert changeset.errors[:account_uid] == {"can't be blank", [validation: :required]}
  	end

  	test "returns invalid with error if the account does not exist", %{ valid_attrs: valid_attrs } do
  		bad_account = Map.put(valid_attrs, :account_uid, "555")
  		changeset = Transaction.changeset(%Transaction{}, bad_account)
      assert false == changeset.valid?
      assert changeset.errors[:account_uid] == {"account not found for uid: 555", [validation: :required]}
  	end

  	test "returns valid changeset when account exists", %{ valid_attrs: valid_attrs } do
  		changeset = Transaction.changeset(%Transaction{}, valid_attrs)
  		assert changeset.valid?
  		{result, _transaction} = Repo.insert(changeset)
  		assert :ok == result
  	end

    test "returns error if no amount_currency", %{ valid_attrs: valid_attrs } do
      no_currency = Map.delete(valid_attrs, :amount_currency)
      changeset = Transaction.changeset(%Transaction{}, no_currency)
      {result, transaction} = Repo.insert(changeset)
      assert :error == result
      assert transaction.errors[:amount_currency] == {"can't be blank", [validation: :required]}
    end

    test "returns error if the amount_currency does not match the account currency", %{ valid_attrs: valid_attrs } do
      bad_currency = Map.put(valid_attrs, :amount_currency, "THB")
      changeset = Transaction.changeset(%Transaction{}, bad_currency)
      assert false == changeset.valid?
      assert changeset.errors[:amount_currency] == {"currency must match accounts currency", [validation: :required]}
    end

    test "returns error if invalid amount_currency", %{ valid_attrs: valid_attrs } do
      bad_currency = Map.put(valid_attrs, :amount_currency, 1234)
      changeset = Transaction.changeset(%Transaction{}, bad_currency)
      {result, transaction} = Repo.insert(changeset)
      assert :error == result
      assert transaction.errors[:amount_currency] == {"is invalid", [{:type, :string}, {:validation, :cast}]}
    end 

    test "returns error if no amount_subunits", %{ valid_attrs: valid_attrs } do
      no_currency = Map.delete(valid_attrs, :amount_subunits)
      changeset = Transaction.changeset(%Transaction{}, no_currency)
      {result, transaction} = Repo.insert(changeset)
      assert :error == result
      assert transaction.errors[:amount_subunits] == {"can't be blank", [validation: :required]}
    end

    test "returns error if invalid amount_subunits", %{ valid_attrs: valid_attrs } do
      bad_currency = Map.put(valid_attrs, :amount_subunits, "abcde")
      changeset = Transaction.changeset(%Transaction{}, bad_currency)
      {result, transaction} = Repo.insert(changeset)
      assert :error == result
      assert transaction.errors[:amount_subunits] == {"is invalid", [{:type, :integer}, {:validation, :cast}]}
    end 

    test "returns error if no kind", %{ valid_attrs: valid_attrs } do
      no_currency = Map.delete(valid_attrs, :kind)
      changeset = Transaction.changeset(%Transaction{}, no_currency)
      {result, transaction} = Repo.insert(changeset)
      assert :error == result
      assert transaction.errors[:kind] == {"can't be blank", [validation: :required]}
    end

    test "returns error if invalid kind", %{ valid_attrs: valid_attrs } do
      bad_currency = Map.put(valid_attrs, :kind, "abcde")
      changeset = Transaction.changeset(%Transaction{}, bad_currency)
      {result, transaction} = Repo.insert(changeset)
      assert :error == result
      assert transaction.errors[:kind] == {"is invalid", [validation: :inclusion, enum: ["credit", "debit"]]}
    end 
  end

  defp create_account() do
    {:ok, account} = HayaiLedger.Accounts.create_account(%{
                        currency: "JPY",
                        kind: "asset",
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
