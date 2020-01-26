defmodule HayaiLedger.LedgersTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Ledgers
  alias HayaiLedger.Ledgers.{Entry, Transaction}

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
    test "returns error if transaction amounts do not balance" do
      
    end

    test "returns error if the transaction currency does not match the account currency" do
      
    end

    test "returns error if the transactions fail" do
      
    end

    test "returns entry upon success" do
      
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
      assert transaction.amount_currency == "some amount_currency"
      assert transaction.amount_subunits == 42
      assert transaction.description == "some description"
      assert transaction.type == "some type"
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

  defp create_account() do
    {:ok, account} = HayaiLedger.Accounts.create_account(%{ name: "Yuko Cash"})
    account
  end

  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(valid_transaction_attrs())
      |> Ledgers.create_entry()

    entry
  end

  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(valid_transaction_attrs())
      |> Ledgers.create_transaction()

    transaction
  end

  def valid_transaction_attrs() do
    %{
      account_id: create_account().id, 
      amount_currency: "some amount_currency", 
      amount_subunits: 42, 
      description: "some description", 
      type: "some type", uid: "some uid"
    }
  end
end
