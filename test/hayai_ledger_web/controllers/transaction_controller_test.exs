defmodule HayaiLedgerWeb.TransactionControllerTest do
  use HayaiLedgerWeb.ConnCase

  import Support.Fixtures.AccountFixtures, only: [{:account_fixture, 0}]

 	alias HayaiLedger.Ledgers

 	 describe "GET /transactions/:uid" do
    test "returns the transaction for the uid", %{conn: conn} do
    	{:ok, entry} = Ledgers.create_entry(%{ description: "testing view" })
    	account = account_fixture()
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

    test "returns error if uid not found", %{conn: conn} do
    	assert %{"error" => "transaction not found for uid: 555"} == get(conn, Routes.transaction_path(conn, :show, "555"))
            																												|> json_response(500)
    end
  end
 end
