defmodule HayaiLedger.LedgersTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Accounts
  alias HayaiLedger.Ledgers
  alias HayaiLedger.Ledgers.{Entry, Transaction}

  describe "entries" do

    @valid_attrs %{description: "some description", object_type: "some object_type", object_uid: "some object_uid"}
    @update_attrs %{description: "some updated description", object_type: "some updated object_type", object_uid: "some updated object_uid"}
    @invalid_attrs %{description: nil, object_type: nil, object_uid: nil, uid: nil}

    setup do
      {:ok, account_1} = Accounts.create_account(%{ name: "One"})
      {:ok, account_2} = Accounts.create_account(%{ name: "Two"})
      %{
        account_1: account_1,
        account_2: account_2
      }
    end

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
      assert entry.uid != nil
    end

    test "create_entry/1 with invalid data returns error changeset" do
      # assert {:error, %Ecto.Changeset{}} = Ledgers.create_entry(@invalid_attrs)
    end

    test "create_bookkeeping_entry/1 returns error tuple if the transactions currency are different", %{ account_1: account_1, account_2: account_2 } do
      thb_transaction_1 = %{amount_currency: "THB", amount_subunits: 100, type: "credit", account_id: account_1.id, description: "description"}
      thb_transaction_2 = %{amount_currency: "THB", amount_subunits: 50, type: "debit", account_id: account_2.id, description: "description"}
      jpy_transaction = %{amount_currency: "JPY", amount_subunits: 50, type: "debit", account_id: account_2.id, description: "description"}
      transactions = [thb_transaction_1, thb_transaction_2, jpy_transaction]
      assert {:error, "currencies do not match"} == Ledgers.create_bookkeeping_entry(@valid_attrs, transactions)
    end

    test "create_bookkeeping_entry/1 returns :ok if the transactions currency are all the same", %{ account_1: account_1, account_2: account_2 } do
      thb_transaction_1 = %{ amount_currency: "THB", amount_subunits: 100, type: "credit", account_id: account_1.id, description: "description" }
      thb_transaction_2 = %{ amount_currency: "THB", amount_subunits: 50, type: "debit", account_id: account_2.id, description: "description" }
      thb_transaction_3 = %{ amount_currency: "THB", amount_subunits: 50, type: "debit", account_id: account_2.id, description: "description" }
      transactions = [thb_transaction_1, thb_transaction_2, thb_transaction_3]
      {:ok, entry} = Ledgers.create_bookkeeping_entry(@valid_attrs, transactions)
      assert @valid_attrs[:description] == entry.description 
      assert @valid_attrs[:object_type] == entry.object_type 
      assert @valid_attrs[:object_uid] == entry.object_uid
      full_entry = Ledgers.get_entry_with_transactions(entry.id)
      assert 3 == length(full_entry.transactions)
    end

    test "create_bookkeeping_entry/1 returns error tuple if the transactions credits and debits do not balance", %{ account_1: account_1, account_2: account_2 } do
      transaction_1 = %{ amount_currency: "THB", amount_subunits: 100, type: "credit", account_id: account_1.id, description: "description" }
      transaction_2 = %{ amount_currency: "THB", amount_subunits: 100, type: "debit", account_id: account_2.id, description: "description" }
      transaction_3 = %{ amount_currency: "THB", amount_subunits: 50, type: "debit", account_id: account_2.id, description: "description" }
      transactions = [transaction_1, transaction_2, transaction_3]
      assert {:error, "credits and debits do not balance"} == Ledgers.create_bookkeeping_entry(@valid_attrs, transactions)
    end

    test "create_bookkeeping_entry/1 returns :ok if the transactions credits and debits balance", %{ account_1: account_1, account_2: account_2 } do
      transaction_1 = %{ amount_currency: "THB", amount_subunits: 150, type: "credit", account_id: account_1.id, description: "description" }
      transaction_2 = %{ amount_currency: "THB", amount_subunits: 100, type: "debit", account_id: account_2.id, description: "description" }
      transaction_3 = %{ amount_currency: "THB", amount_subunits: 50, type: "debit", account_id: account_2.id, description: "description" }
      transactions = [transaction_1, transaction_2, transaction_3]
      {:ok, entry} = Ledgers.create_bookkeeping_entry(@valid_attrs, transactions)
      assert entry.description == @valid_attrs[:description]
      assert entry.object_type == @valid_attrs[:object_type]
      assert entry.object_uid == @valid_attrs[:object_uid]
      full_entry = Ledgers.get_entry_with_transactions(entry.id)
      assert 3 == length(full_entry.transactions)
    end
 
    test "create_bookeeping_entry/1 retuns error tuple if less than 2 transactions are included", %{ account_1: account_1 } do
      transaction = %{ amount_currency: "THB", amount_subunits: 150, type: "credit", account_id: account_1.id, description: "description"}
      bad_transactions = [nil, "", %{}, transaction, [transaction]]
      for bad_transaction <- bad_transactions do
        assert {:error, "must include transactions that balance"} == Ledgers.create_bookkeeping_entry(@valid_attrs, bad_transaction)
      end
    end

    test "create_bookeeping_entry/1 returns error tuple if accounts are invalid", %{ account_1: account_1 } do
      transaction_1 = %{ amount_currency: "THB", amount_subunits: 150, type: "credit", account_id: account_1.id, description: "description" }
      transaction_2 = %{ amount_currency: "THB", amount_subunits: 100, type: "debit", account_id: account_1.id, description: "description" }
      transaction_3 = %{ amount_currency: "THB", amount_subunits: 50, type: "debit", account_id: 555, description: "description" }
      transactions = [transaction_1, transaction_2, transaction_3]
      assert {:error, "invalid account id: 555"} == Ledgers.create_bookkeeping_entry(@valid_attrs, transactions)
    end

    # test "update_entry/2 with valid data updates the entry" do
    #   entry = entry_fixture()
    #   assert {:ok, %Entry{} = entry} = Ledgers.update_entry(entry, @update_attrs)
    #   assert entry.description == "some updated description"
    #   assert entry.object_type == "some updated object_type"
    #   assert entry.object_uid == "some updated object_uid"
    #   assert entry.uid == "some updated uid"
    # end

    # test "update_entry/2 with invalid data returns error changeset" do
    #   entry = entry_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Ledgers.update_entry(entry, @invalid_attrs)
    #   assert entry == Ledgers.get_entry!(entry.id)
    # end

    # test "delete_entry/1 deletes the entry" do
    #   entry = entry_fixture()
    #   assert {:ok, %Entry{}} = Ledgers.delete_entry(entry)
    #   assert_raise Ecto.NoResultsError, fn -> Ledgers.get_entry!(entry.id) end
    # end

    # test "change_entry/1 returns a entry changeset" do
    #   entry = entry_fixture()
    #   assert %Ecto.Changeset{} = Ledgers.change_entry(entry)
    # end
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
      assert transaction.uid != nil
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
      assert transaction.uid != nil
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
