defmodule HayaiLedgerWeb.EntryControllerTest do
  use HayaiLedgerWeb.ConnCase

 	alias HayaiLedger.Ledgers

  describe "GET /entries/:uid" do
    test "returns the entry for the uid", %{conn: conn} do
      {:ok, entry} = Ledgers.create_entry(%{ description: "testing create" })
      response = get(conn, Routes.entry_path(conn, :show, entry.uid))
            |> json_response(200)

      assert entry.uid == response["uid"]
      assert "Entry" == response["object"]
      assert entry.description == response["description"]
    end
  end

  describe "GET /entries/transactions/:uid" do
    test "returns the transactions for the entry", %{conn: conn} do
      asset_account = create_account(%{ name: "asset acount", currency: "THB", kind: "asset" })
      tax_account = create_account(%{ name: "tax account", currency: "THB", kind: "liability" })
      equity_account = create_account(%{ name: "equity account", currency: "THB", kind: "equity" })
      transaction_1 = Ledgers.build_transaction(%{ "account_uid" => asset_account.uid, "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "debit" })
      transaction_2 = Ledgers.build_transaction(%{ "account_uid" => tax_account.uid, "amount_currency" => "THB", "amount_subunits" => 100, "kind" => "credit" })
      transaction_3 = Ledgers.build_transaction(%{ "account_uid" => equity_account.uid, "amount_currency" => "THB", "amount_subunits" => 900, "kind" => "credit" })
      entry_attrs = %{ "description" => "test create journal entry"}
      {:ok, entry} = Ledgers.journal_entry(entry_attrs, [transaction_1, transaction_2, transaction_3])

      response = get(conn, Routes.entry_path(conn, :transactions_show, entry.uid))
                |> json_response(200)

      assert entry.uid == response["uid"]
      assert "Entry" == response["object"]
      assert entry.description == response["description"]
      assert 3 == length(response["transactions"])
      for transaction <- response["transactions"] do
        assert nil != transaction["amount_subunits"]
        assert "THB" == transaction["amount_currency"]
        assert entry.uid == transaction["entry_uid"]
        assert nil != transaction["kind"]
        assert "Transaction" == transaction["object"]
        assert nil != transaction["uid"]
      end
    end
  end

 	describe "POST /entries/create" do
    setup do
      asset_account = create_account(%{ name: "asset acount", currency: "THB", kind: "asset" })
      tax_account = create_account(%{ name: "tax account", currency: "THB", kind: "liability" })
      equity_account = create_account(%{ name: "equity account", currency: "THB", kind: "equity" })
      entry_attrs = %{ "description" => "test create journal entry"}
      %{
        asset_account: asset_account,
        tax_account: tax_account,
        equity_account: equity_account,
        entry_attrs: entry_attrs
      }
    end

    test "returns a journal entry upon success", %{conn: conn} = context do
      transaction_1 = %{ "account_uid" => context.asset_account.uid, "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "debit" }
      transaction_2 = %{ "account_uid" => context.tax_account.uid, "amount_currency" => "THB", "amount_subunits" => 100, "kind" => "credit" }
      transaction_3 = %{ "account_uid" => context.equity_account.uid, "amount_currency" => "THB", "amount_subunits" => 900, "kind" => "credit" }
      journal_entry_params = %{ "entry" => context.entry_attrs, "transactions" => [transaction_1, transaction_2, transaction_3] }

  		response = post(conn, Routes.entry_path(conn, :create), journal_entry: journal_entry_params)
  		      		|> json_response(200)
  		
      {:ok, entry} = Ledgers.get_entry_by_uid(response["uid"])
      full_entry = Ledgers.get_entry_with_transactions(entry.id)
      assert 3 == length(full_entry.transactions)
    end

    test "returns a safe journal entry upon success", %{conn: conn} = context do
      transaction_1 = %{ "account_uid" => context.asset_account.uid, "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "debit" }
      transaction_2 = %{ "account_uid" => context.tax_account.uid, "amount_currency" => "THB", "amount_subunits" => 100, "kind" => "credit" }
      transaction_3 = %{ "account_uid" => context.equity_account.uid, "amount_currency" => "THB", "amount_subunits" => 900, "kind" => "credit" }
      options = %{ "account" => context.asset_account.uid, "minimum" => "non_negative" }
      journal_entry_params = %{ "entry" => context.entry_attrs, "transactions" => [transaction_1, transaction_2, transaction_3], "options" => options }

      response = post(conn, Routes.entry_path(conn, :create), journal_entry: journal_entry_params)
                |> json_response(200)
      
      {:ok, entry} = Ledgers.get_entry_by_uid(response["uid"])
      full_entry = Ledgers.get_entry_with_transactions(entry.id)
      assert 3 == length(full_entry.transactions)
    end

    test "returns error if transactions are invalid", %{conn: conn} = context do
      transaction_1 = %{ "amount_currency" => "THB", "amount_subunits" => 1000, "kind" => "debit" }
      transaction_2 = %{ "amount_currency" => "THB", "amount_subunits" => 100, "kind" => "credit" }
      transaction_3 = %{ "amount_currency" => "THB", "amount_subunits" => 900, "kind" => "credit" }
      journal_entry_params = %{ "entry" => context.entry_attrs, "transactions" => [transaction_1, transaction_2, transaction_3] }
      response = post(conn, Routes.entry_path(conn, :create), journal_entry: journal_entry_params)
                |> json_response(500)

      assert %{"error" => "transactions must be valid"} == response
    end
 	end

  defp create_account(attrs) do
    {:ok, account} =
      attrs
      |> Enum.into(valid_account_attrs()) 
      |> HayaiLedger.Accounts.create_account()

    account
  end

  defp valid_account_attrs() do
    %{
      currency: "THB",
      kind: "equity",
      name: "Yuko Cash",
    }
  end
 end
