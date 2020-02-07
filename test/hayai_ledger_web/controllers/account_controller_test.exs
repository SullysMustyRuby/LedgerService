defmodule HayaiLedgerWeb.AccountControllerTest do
  use HayaiLedgerWeb.ConnCase

 	alias HayaiLedger.Accounts
 	alias HayaiLedger.Ledgers

  @valid_account_params %{
  	"currency" => "THB",
  	"kind" => "asset", 
  	"meta_data" => %{ "merchant" => 1234, "code" => "happy", "name" => "whizzle teeth" }, 
  	"name" => "some updated name", 
  	"object_type" => "some updated object_type", 
  	"object_uid" => "some updated object_uid"
  }

  describe "GET /balance/:uid" do
  	test "returns the balance json", %{conn: conn} do
  		account = create_account()
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_uid: account.uid, amount_subunits: 1000, kind: "credit" }))
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_uid: account.uid, amount_subunits: 1000, kind: "debit" }))
      Ledgers.create_transaction(valid_transaction_attrs(%{ account_uid: account.uid, amount_subunits: 1000, kind: "credit" }))
      response = get(conn, Routes.account_path(conn, :balance, account.uid))
      						|> json_response(200)

      assert account.uid == response["account_uid"]
      assert "THB" == response["amount_currency"]
      assert 1000 == response["amount_subunits"]
      assert nil != response["date"]
  	end

  	test "returns an error if account cannot be found", %{conn: conn} do
  		resp_conn = get(conn, Routes.account_path(conn, :balance, "555"))
	  	assert %{"error" => "account not found for uid: 555"} == json_response(resp_conn, 500)
  	end
  end

  describe "POST /create" do
  	test "returns an account with valid params", %{conn: conn} do
  		response = post(conn, Routes.account_path(conn, :create), account: @valid_account_params)
    							|> json_response(200)
    							|> Map.delete("uid")
    							|> Map.delete("type")

    	assert @valid_account_params == response
	  end

	  test "returns an error if invalid data", %{conn: conn} do
	  	resp_conn = post(conn, Routes.account_path(conn, :create), account: %{ "name" => "not enough info" })
	  	assert %{"currency" => "can't be blank", "kind" => "can't be blank"} == json_response(resp_conn, 500)
	  end
  end

  describe "GET /show/:uid" do
  	test "returns the found account", %{conn: conn} do
  		{:ok, account} = Accounts.create_account(@valid_account_params)
  		response = get(conn, Routes.account_path(conn, :show, account.uid))
  		 						|> json_response(200)
    							|> Map.delete("uid")
    							|> Map.delete("type")

    	assert @valid_account_params == response
  	end

	  test "returns the error if invalid uid", %{conn: conn} do
	  	resp_conn = get(conn, Routes.account_path(conn, :show, "555"))
	  	assert %{"error" => "account not found for uid: 555"} == json_response(resp_conn, 500)
	  end
  end

  defp create_account(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@valid_account_params) 
      |> HayaiLedger.Accounts.create_account()

    account
  end

  defp valid_transaction_attrs(attrs) do
    Enum.into(attrs, %{
      account_id: create_account().id, 
      amount_currency: "THB", 
      amount_subunits: 42, 
      kind: "credit"
    })
  end
end
