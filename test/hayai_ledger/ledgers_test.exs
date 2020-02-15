defmodule HayaiLedger.LedgersTest do
  use HayaiLedger.DataCase

  alias HayaiLedger.Accounts
  alias HayaiLedger.Ledgers
  alias HayaiLedger.Ledgers.{Entry, Transaction}
  alias HayaiLedger.LockServer

  import Support.Fixtures.LedgerFixtures
  import Support.Fixtures.AccountFixtures

  @valid_entry_attrs %{description: "some description", object_type: "some object_type", object_uid: "some object_uid"}
  @invalid_transaction_attrs %{amount_currency: nil, amount_subunits: nil, description: nil, type: nil, uid: nil}

  describe "build_entry/1" do
    test "returns a entry chageset" do
      changeset = Ledgers.build_entry(@valid_entry_attrs)
      assert [] == changeset.errors
      assert changeset.valid?
    end
  end

  describe "build_transaction/1" do
    test "returns a transaction chageset" do
      changeset = Ledgers.build_transaction(transaction_attrs())
      assert [] == changeset.errors
      assert changeset.valid?
    end

    test "returns an error with invalid attributes" do
      changeset = Ledgers.build_transaction(@invalid_transaction_attrs)
      assert false == changeset.valid?
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
      assert {:ok, %Transaction{} = transaction} = Ledgers.create_transaction(transaction_attrs())
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
      assert entry == Ledgers.get_entry!(entry.id)
    end
  end

  describe "get_entry_by_uid/1" do
    test "returns the entry if found" do
      entry = entry_fixture()
      {:ok, found_entry} = Ledgers.get_entry_by_uid(entry.uid)
      assert entry.id == found_entry.id
    end

    test "returns an error entry if not found" do
      assert {:error, "entry not found for uid: 555"} == Ledgers.get_entry_by_uid("555")
    end

    test "returns an error if uid is not string" do
      assert {:error, "entry not found"} == Ledgers.get_entry_by_uid(555)
    end
  end

  describe "get_transaction_by_uid/1" do
    test "returns the transaction if found" do
      entry = entry_fixture()
      account = account_fixture()
      transaction = transaction_fixture(%{ "entry_id" => entry.id, "account_uid" => account.uid })
      {:ok, transaction} = Ledgers.get_transaction_by_uid(transaction.uid)
      assert entry.id == transaction.entry_id
      assert account.id == transaction.account_id
    end

    test "returns an error transaction if not found" do
      assert {:error, "transaction not found for uid: 555"} == Ledgers.get_transaction_by_uid("555")
    end

    test "returns an error if uid is not string" do
      assert {:error, "transaction not found"} == Ledgers.get_transaction_by_uid(555)
    end
  end

  describe "get_entry_uid/1" do
    test "returns the uid for the entry id" do
      entry = entry_fixture()
      assert entry.uid == Ledgers.get_entry_uid(entry.id)
    end

    test "returns nil if entry not found" do
      assert nil == Ledgers.get_entry_uid(555)
    end
  end

  describe "get_entry_with_transactions/1" do
  end
  
  describe "get_transaction!/1" do
    test "returns the transaction with given id" do
      transaction = transaction_fixture() |> Map.delete(:account_uid)
      assert transaction == Ledgers.get_transaction!(transaction.id) |> Map.delete(:account_uid)
    end
  end

  describe "journal_entry/2" do
    test "returns error if no transactions" do
      assert {:error, "must have transactions that balance"} == Ledgers.journal_entry(@valid_entry_attrs, [])
    end

    test "returns error if transaction amounts do not balance" do
      transaction_1 = build_transaction(%{ "amount_subunits" => 1000, "kind" => "credit" })
      transaction_2 = build_transaction(%{ "amount_subunits" => 1000, "kind" => "debit" })
      transaction_3 = build_transaction(%{ "amount_subunits" => 1000, "kind" => "credit" })
      assert {:error, "credits and debits do not balance"} == Ledgers.journal_entry(@valid_entry_attrs, [transaction_1, transaction_2, transaction_3])

      thai_account = account_fixture(%{ "currency" => "THB" })
      transaction_1 = build_transaction(%{ "amount_subunits" => 1000, "kind" => "credit" })
      transaction_2 = build_transaction(%{ "account_uid" => thai_account.uid, "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "debit" })
      transaction_3 = build_transaction(%{ "account_uid" => thai_account.uid, "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "credit" })
      assert {:error, "credits and debits do not balance"} == Ledgers.journal_entry(@valid_entry_attrs, [transaction_1, transaction_2, transaction_3])
    end

    test "returns error if transactions are invalid" do
      transaction_1 = build_transaction(%{ "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "credit" })
      transaction_2 = build_transaction(%{ "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "debit" })
      assert {:error, "transactions must be valid"} == Ledgers.journal_entry(@valid_entry_attrs, [transaction_1, transaction_2])
    end

    test "returns error if a transaction account is locked" do
      locked_account = account_fixture(%{ "currency" => "THB" })
      transaction_1 = build_transaction(%{ "account_uid" => locked_account.uid, "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "credit" })
      transaction_2 = build_transaction(%{ "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "debit" })
      LockServer.account_lock(locked_account.uid)
      assert {:error, "transactions must be valid"} == Ledgers.journal_entry(@valid_entry_attrs, [transaction_1, transaction_2])
    end

    test "returns error if the transactions fail" do
      transaction_1 = build_transaction(%{ "amount_currency" => "JPY",  "amount_subunits" => 500, "kind" => "credit" })
      transaction_2 = build_transaction(%{ "amount_currency" => "JPY",  "amount_subunits" => 1000, "kind" => "debit" })
      transaction_3 = build_transaction(%{ "amount_currency" => "JPY",  "amount_subunits" => 500, "kind" => "credit" })
      transaction_4 = build_transaction(%{ "account_id" => 555, "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "debit" })
      transaction_5 = build_transaction(%{ "account_id" => 555, "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "credit" })
      assert {:error, "transactions must be valid"} == Ledgers.journal_entry(@valid_entry_attrs, [transaction_1, transaction_2, transaction_3, transaction_4, transaction_5])
      assert 0 == Repo.one(from t in "transactions", select: count(t.id))
      assert 0 == Repo.one(from e in "entries", select: count(e.id))
    end

    test "returns entry upon success" do
      asset_account = account_fixture(%{ "kind" => "asset" })
      equity_account = account_fixture(%{ "kind" => "equity" })
      liability_account = account_fixture(%{ "kind" => "liability" })

      assert 0 = Accounts.balance_amount_subunits_for_account(asset_account.id)
      assert 0 = Accounts.balance_amount_subunits_for_account(equity_account.id)
      assert 0 = Accounts.balance_amount_subunits_for_account(liability_account.id)

      transaction_1 = build_transaction(%{ "account_uid" => asset_account.uid, "amount_subunits" => 1000, "kind" => "debit" })
      transaction_2 = build_transaction(%{ "account_uid" => equity_account.uid, "amount_subunits" => 500, "kind" => "credit" })
      transaction_3 = build_transaction(%{ "account_uid" => liability_account.uid, "amount_subunits" => 500, "kind" => "credit" })
      
      {:ok, entry, transactions} = Ledgers.journal_entry(@valid_entry_attrs, [transaction_1, transaction_2, transaction_3])
      assert nil != entry.uid
      assert 3 == length(transactions)
      assert -1000 = Accounts.balance_amount_subunits_for_account(asset_account.id)
      assert 500 = Accounts.balance_amount_subunits_for_account(equity_account.id)
      assert 500 = Accounts.balance_amount_subunits_for_account(liability_account.id)
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
      transaction = transaction_fixture() |> Map.delete(:account_uid)
      assert transaction == Ledgers.list_transactions() |> hd() |> Map.delete(:account_uid)
    end
  end

  describe "list_transactions/1" do
    test "returns all transactions for the account_id" do
      asset_account = account_fixture(%{ "kind" => "asset" })
      equity_account = account_fixture(%{ "kind" => "equity" })
      transaction_fixture(%{ "account_uid" => equity_account.uid })
      transaction_fixture(%{ "account_uid" => asset_account.uid })

      [transaction] = Ledgers.list_transactions(asset_account.id)
      assert asset_account.id == transaction.account_id
    end
  end

  describe "safe_journal_entry/3" do
    setup do
      asset_account = account_fixture(%{ "kind" => "asset" })
      equity_account = account_fixture(%{ "kind" => "equity" })
      liability_account = account_fixture(%{ "kind" => "liability" })
      %{
        asset_account: asset_account,
        equity_account: equity_account,
        liability_account: liability_account,
        transaction_1: Ledgers.build_transaction(%{ account_uid: asset_account.uid, amount_currency: asset_account.currency, amount_subunits: 1000, kind: "debit" }),
        transaction_2: Ledgers.build_transaction(%{ account_uid: equity_account.uid, amount_currency: equity_account.currency, amount_subunits: 500, kind: "credit" }),
        transaction_3: Ledgers.build_transaction(%{ account_uid: liability_account.uid, amount_currency: liability_account.currency, amount_subunits: 500, kind: "credit" }),
      }
    end

    test "returns error if account is locked", context do
      LockServer.account_lock(context.liability_account.uid)
      transaction_3 = Ledgers.build_transaction(%{ account_uid: context.liability_account.uid, amount_currency: context.liability_account.currency, amount_subunits: 500, kind: "credit" })
      check_options = %{ account: context.equity_account.uid, minimum: "non_negative" }
      transactions = [context.transaction_1, context.transaction_2, transaction_3]
      assert {:error, "transactions must be valid" } == Ledgers.safe_journal_entry(@valid_entry_attrs, transactions, check_options)
    end

    test "returns error when balance will be negative", context do
      transaction_fixture(%{ "account_uid" => context.equity_account.uid, "amount_subunits" => 500 })
      assert 500 == Ledgers.transactions_sum_by_account(context.equity_account.id)
 
      transaction_1 = Ledgers.build_transaction(%{ account_uid: context.asset_account.uid, amount_currency: context.asset_account.currency, amount_subunits: 600, kind: "credit" })
      transaction_2 = Ledgers.build_transaction(%{ account_uid: context.equity_account.uid, amount_currency: context.equity_account.currency, amount_subunits: 600, kind: "debit" })

      check_options = %{ account: context.equity_account.uid, minimum: "non_negative" }
      assert {:error, "transactions fail balance check"} == Ledgers.safe_journal_entry(@valid_entry_attrs, [transaction_1, transaction_2], check_options)
    end

    test "returns error when balance will be below minimum", context do
      transaction_fixture(%{ "account_uid" => context.equity_account.uid, "amount_subunits" => 500 })
      assert 500 == Ledgers.transactions_sum_by_account(context.equity_account.id)
 
      transaction_1 = Ledgers.build_transaction(%{ account_uid: context.asset_account.uid, amount_currency: context.asset_account.currency, amount_subunits: 300, kind: "credit" })
      transaction_2 = Ledgers.build_transaction(%{ account_uid: context.equity_account.uid, amount_currency: context.equity_account.currency, amount_subunits: 300, kind: "debit" })

      check_options = %{ account: context.equity_account.uid, minimum: "300" }
      assert {:error, "transactions fail balance check"} == Ledgers.safe_journal_entry(@valid_entry_attrs, [transaction_1, transaction_2], check_options)
    end

    test "returns ok entry when success", context do
      assert 0 = Accounts.balance_amount_subunits_for_account(context.asset_account.id)
      assert 0 = Accounts.balance_amount_subunits_for_account(context.equity_account.id)
      assert 0 = Accounts.balance_amount_subunits_for_account(context.liability_account.id)

      transactions = [context.transaction_1, context.transaction_2, context.transaction_3]
      check_options = %{ account: context.equity_account.uid, minimum: "non_negative" }
      
      {:ok, entry, transactions} = Ledgers.safe_journal_entry(@valid_entry_attrs, transactions, check_options)

      assert nil != entry.uid
      assert 3 == length(transactions)
      assert -1000 = Accounts.balance_amount_subunits_for_account(context.asset_account.id)
      assert 500 = Accounts.balance_amount_subunits_for_account(context.equity_account.id)
      assert 500 = Accounts.balance_amount_subunits_for_account(context.liability_account.id)
    end
  end

  describe "transactions_sum_by_account/1" do
    setup do
      %{
        account: account_fixture()
      }
    end

    test "returns the difference of the credits and debits", %{ account: account } do
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "credit" })
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "debit" })
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "credit" })
      assert 1000 == Ledgers.transactions_sum_by_account(account.id)
    end

    test "returns 0 if no account" do
      assert 0 == Ledgers.transactions_sum_by_account("555")
    end

    test "returns 0 if no credits or debits", %{ account: account } do
      assert 0 == Ledgers.transactions_sum_by_account(account.id)
    end

    test "returns the credits balance if no debits", %{ account: account } do
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "credit" })
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "credit" })
      assert 2000 == Ledgers.transactions_sum_by_account(account.id)
    end

    test "returns the debits balance if no credits", %{ account: account } do
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "debit" })
      transaction_fixture(%{ "account_uid" => account.uid, "amount_subunits" => 1000, "kind" => "debit" })
      assert -2000 == Ledgers.transactions_sum_by_account(account.id)
    end
  end

  defp build_transaction(attrs) do
    attrs
    |> Enum.into(transaction_attrs())
    |> Ledgers.build_transaction()
  end
end
