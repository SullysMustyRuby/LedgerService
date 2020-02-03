defmodule HayaiLedger.LedgersTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Ledgers
  alias HayaiLedger.Ledgers.{Entry, Transaction}
  alias HayaiLedger.Repo

  @valid_entry_attrs %{description: "some description", object_type: "some object_type", object_uid: "some object_uid"}
  @invalid_transaction_attrs %{amount_currency: nil, amount_subunits: nil, description: nil, type: nil, uid: nil}

  describe "build_transaction/1" do
    test "returns a transaction chageset" do
      changeset = Ledgers.build_transaction(valid_transaction_attrs())
      assert [] == changeset.errors
      assert changeset.valid?
    end

    test "returns an error with invalid attributes" do
      changeset = Ledgers.build_transaction(@invalid_transaction_attrs)
      assert false == changeset.valid?
    end
  end

  describe "create_bookeeping_entry/2" do
    test "returns error if no transactions" do
      assert {:error, "must have transactions that balance"} == Ledgers.create_bookeeping_entry(@valid_entry_attrs, [])
    end

    test "returns error if transaction amounts do not balance" do
      transaction_1 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_subunits: 1000, kind: "credit" }))
      transaction_2 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_subunits: 1000, kind: "debit" }))
      transaction_3 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_subunits: 1000, kind: "credit" }))
      assert {:error, "credits and debits do not balance"} == Ledgers.create_bookeeping_entry(@valid_entry_attrs, [transaction_1, transaction_2, transaction_3])

      thai_account = create_account(%{ currency: "THB" })
      transaction_1 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_subunits: 1000, kind: "credit" }))
      transaction_2 = Ledgers.build_transaction(valid_transaction_attrs(%{ account_id: thai_account.id, amount_currency: "THB", amount_subunits: 1000, kind: "debit" }))
      transaction_3 = Ledgers.build_transaction(valid_transaction_attrs(%{ account_id: thai_account.id, amount_currency: "THB", amount_subunits: 1000, kind: "credit" }))
      assert {:error, "credits and debits do not balance"} == Ledgers.create_bookeeping_entry(@valid_entry_attrs, [transaction_1, transaction_2, transaction_3])
    end

    test "returns error if transactions are invalid" do
      transaction_1 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_currency: "THB", amount_subunits: 1000, kind: "credit" }))
      transaction_2 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_currency: "THB", amount_subunits: 1000, kind: "debit" }))
      assert {:error, "transactions must be valid"} == Ledgers.create_bookeeping_entry(@valid_entry_attrs, [transaction_1, transaction_2])
    end

    test "returns error if the transactions fail" do
      transaction_1 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_currency: "JPY",  amount_subunits: 500, kind: "credit" }))
      transaction_2 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_currency: "JPY",  amount_subunits: 1000, kind: "debit" }))
      transaction_3 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_currency: "JPY",  amount_subunits: 500, kind: "credit" }))
      transaction_4 = Ledgers.build_transaction(valid_transaction_attrs(%{ account_id: 555, amount_currency: "THB", amount_subunits: 1000, kind: "debit" }))
      transaction_5 = Ledgers.build_transaction(valid_transaction_attrs(%{ account_id: 555, amount_currency: "THB", amount_subunits: 1000, kind: "credit" }))
      assert {:error, "database error"} = Ledgers.create_bookeeping_entry(@valid_entry_attrs, [transaction_1, transaction_2, transaction_3, transaction_4, transaction_5])
      assert 0 == Repo.one(from t in "transactions", select: count(t.id))
      assert 0 == Repo.one(from e in "entries", select: count(e.id))
    end

    test "returns entry upon success" do
      thai_account = create_account(%{ currency: "THB" })
      transaction_1 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_currency: "JPY",  amount_subunits: 500, kind: "credit" }))
      transaction_2 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_currency: "JPY",  amount_subunits: 1000, kind: "debit" }))
      transaction_3 = Ledgers.build_transaction(valid_transaction_attrs(%{ amount_currency: "JPY",  amount_subunits: 500, kind: "credit" }))
      transaction_4 = Ledgers.build_transaction(valid_transaction_attrs(%{ account_id: thai_account.id, amount_currency: "THB", amount_subunits: 1000, kind: "debit" }))
      transaction_5 = Ledgers.build_transaction(valid_transaction_attrs(%{ account_id: thai_account.id, amount_currency: "THB", amount_subunits: 1000, kind: "credit" }))
      {:ok, entry} = Ledgers.create_bookeeping_entry(@valid_entry_attrs, [transaction_1, transaction_2, transaction_3, transaction_4, transaction_5])
      full_entry = Ledgers.get_entry_with_transactions(entry.id)
      assert 5 == length(full_entry.transactions)
    end
  end

  describe "create_entry/1" do
    test "with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Ledgers.create_entry(@valid_entry_attrs)
      assert entry.description == "some description"
      assert entry.object_type == "some object_type"
      assert entry.object_uid == "some object_uid"
      assert entry.uid != nil
    end
  end

  describe "create_transaction/1" do
    test "with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Ledgers.create_transaction(valid_transaction_attrs())
      assert transaction.amount_currency == "JPY"
      assert transaction.amount_subunits == 42
      assert transaction.kind == "credit"
      assert transaction.uid != nil
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ledgers.create_transaction(@invalid_transaction_attrs)
    end
  end

  describe "get_entry/1" do
    test "returns the entry with given id" do
      entry = entry_fixture()
      assert Ledgers.get_entry!(entry.id) == entry
    end
  end

  describe "get_entry_with_transactions/1" do
  end
  
  describe "get_transaction!/1" do
    test "returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Ledgers.get_transaction!(transaction.id) == transaction
    end
  end

  describe "list_entries/0" do
    test "returns all entries" do
      entry = entry_fixture()
      assert Ledgers.list_entries() == [entry]
    end
  end

  describe "list_transactions/0" do
    test "returns all transactions" do
      transaction = transaction_fixture()
      assert Ledgers.list_transactions() == [transaction]
    end
  end

  describe "sum_credits_and_debits_for_account" do
    test "returns the difference of the credits and debits" do
      account = create_account()
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "credit" }))
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "debit" }))
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "credit" }))
      assert 1000 == Ledgers.sum_credits_and_debits_for_account(account.id)
    end

    test "returns 0 if no credits or debits" do
      account = create_account()
      assert 0 == Ledgers.sum_credits_and_debits_for_account(account.id)
    end

    test "returns the credits balance if no debits" do
      account = create_account()
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "credit" }))
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "credit" }))
      assert 2000 == Ledgers.sum_credits_and_debits_for_account(account.id)
    end

    test "returns the debits balance if no credits" do
      account = create_account()
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "debit" }))
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_id: account.id, amount_subunits: 1000, kind: "debit" }))
      assert -2000 == Ledgers.sum_credits_and_debits_for_account(account.id)
    end
  end

  defp create_account(attrs \\ %{}) do
    {:ok, account} = Enum.into(attrs, valid_account_attrs()) |> HayaiLedger.Accounts.create_account()
    account
  end

  defp create_account_type() do
    {:ok, type} = HayaiLedger.Accounts.create_account_type(%{ name: "cash" })
    type
  end

  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(valid_transaction_attrs())
      |> Ledgers.create_entry()

    entry
  end

  defp transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(valid_transaction_attrs())
      |> Ledgers.create_transaction()

    transaction
  end

  defp valid_account_attrs() do
    %{
      currency: "JPY",
      name: "Yuko Cash",
      type_id: create_account_type().id
    }
  end

  defp valid_transaction_attrs(attrs \\ %{}) do
    Enum.into(attrs, %{
      account_id: create_account().id, 
      amount_currency: "JPY", 
      amount_subunits: 42, 
      kind: "credit"
    })
  end
end
