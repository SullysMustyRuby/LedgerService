defmodule HayaiLedgerWeb.Api.AccountView do
  use HayaiLedgerWeb, :api_view

  alias HayaiLedgerWeb.Api.TransactionView

  def render("balance.json", %{ account: %{ uid: uid, currency: currency }, amount_subunits: amount_subunits }) do
  	%{
  		"object" => "AccountRunningBalance",
		  "account_uid" => uid,
		  "amount_subunits" => amount_subunits,
		  "amount_currency" => currency,
		  "date" => DateTime.utc_now()|> DateTime.to_iso8601() 
		}
  end

  def render("new.json", %{ account: account }) do
  	%{
  		"object" => "Account",
			"currency" => account.currency,
			"kind" => account.kind,
			"meta_data" => account.meta_data,
			"name" => account.name,
			"object_type" => account.object_type,
			"object_uid" => account.object_uid,
			"uid" => account.uid,
			"type" => account.type
		}
  end
  
  def render("show.json", %{ account: account, transactions: transactions }) do
  	%{
  		"object" => "Account",
			"currency" => account.currency,
			"kind" => account.kind,
			"meta_data" => account.meta_data,
			"name" => account.name,
			"object_type" => account.object_type,
			"object_uid" => account.object_uid,
			"uid" => account.uid,
			"type" => account.type,
			"transactions" => render_many(transactions, TransactionView, "show.json")
		}
  end

  def render("show.json", %{ account: account }) do
  	%{
  		"object" => "Account",
			"currency" => account.currency,
			"kind" => account.kind,
			"meta_data" => account.meta_data,
			"name" => account.name,
			"object_type" => account.object_type,
			"object_uid" => account.object_uid,
			"uid" => account.uid,
			"type" => account.type
		}
  end

  def render("error.json", %{ errors: errors }) do
  	errors
  end
end
