defmodule HayaiLedgerWeb.TransactionControllerTest do
  use HayaiLedgerWeb.ConnCase

 	alias HayaiLedger.Ledgers
 	alias HayaiLedgerWeb.TransactionController

 	 describe "GET /transactions/:uid" do
    test "returns the transaction for the uid", %{conn: conn} do
    	{:ok, entry} = Ledgers.create_entry(%{ description: "testing view" })
    	account = create_account()
      valid_transaction_attrs = %{ account_uid: account.uid, amount_currency: "JPY", amount_subunits: 42, entry_id: entry.id, kind: "credit" }
      {:ok, transaction} = Ledgers.create_transaction(valid_transaction_attrs)
      response = get(conn, Routes.transaction_path(conn, :show, transaction.uid))
            |> json_response(200)

      assert account.uid == response["account_uid"]
      assert transaction.amount_currency == response["amount_currency"]
      assert transaction.amount_subunits == response["amount_subunits"]
      assert transaction.description == response["description"]
      assert entry.uid == response["entry_uid"]
      assert transaction.kind == response["kind"]
      assert "Transaction" == response["object"]
      assert transaction.uid == response["uid"]
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
