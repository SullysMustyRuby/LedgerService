defmodule HayaiLedger.LedgersTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Ledgers
  alias HayaiLedger.Ledgers.{Entry, Transaction}

  describe "entries" do

    @valid_attrs %{description: "some description", object_type: "some object_type", object_uid: "some object_uid", uid: "some uid"}
    @update_attrs %{description: "some updated description", object_type: "some updated object_type", object_uid: "some updated object_uid", uid: "some updated uid"}
    @invalid_attrs %{description: nil, object_type: nil, object_uid: nil, uid: nil}

    def entry_fixture(attrs \\ %{}) do
      {:ok, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ledgers.create_entry()

      entry
    end

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Ledgers.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Ledgers.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Ledgers.create_entry(@valid_attrs)
      assert entry.description == "some description"
      assert entry.object_type == "some object_type"
      assert entry.object_uid == "some object_uid"
      assert entry.uid == "some uid"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ledgers.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{} = entry} = Ledgers.update_entry(entry, @update_attrs)
      assert entry.description == "some updated description"
      assert entry.object_type == "some updated object_type"
      assert entry.object_uid == "some updated object_uid"
      assert entry.uid == "some updated uid"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Ledgers.update_entry(entry, @invalid_attrs)
      assert entry == Ledgers.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Ledgers.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Ledgers.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Ledgers.change_entry(entry)
    end
  end

  describe "transactions" do

    @valid_attrs %{amount_currency: "some amount_currency", amount_subunits: 42, description: "some description", type: "some type", uid: "some uid"}
    @update_attrs %{amount_currency: "some updated amount_currency", amount_subunits: 43, description: "some updated description", type: "some updated type", uid: "some updated uid"}
    @invalid_attrs %{amount_currency: nil, amount_subunits: nil, description: nil, type: nil, uid: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ledgers.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Ledgers.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Ledgers.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Ledgers.create_transaction(@valid_attrs)
      assert transaction.amount_currency == "some amount_currency"
      assert transaction.amount_subunits == 42
      assert transaction.description == "some description"
      assert transaction.type == "some type"
      assert transaction.uid == "some uid"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ledgers.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Ledgers.update_transaction(transaction, @update_attrs)
      assert transaction.amount_currency == "some updated amount_currency"
      assert transaction.amount_subunits == 43
      assert transaction.description == "some updated description"
      assert transaction.type == "some updated type"
      assert transaction.uid == "some updated uid"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Ledgers.update_transaction(transaction, @invalid_attrs)
      assert transaction == Ledgers.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Ledgers.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Ledgers.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Ledgers.change_transaction(transaction)
    end
  end
end
