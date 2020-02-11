defmodule HayaiLedgerWeb.AccountView do
  use HayaiLedgerWeb, :view

  def render("balance.json", %{ account: %{ uid: uid, currency: currency }, balance: balance }) do
  	%{
  		"object" => "AccountBalance",
		  "account_uid": uid,
		  "amount_subunits": balance,
		  "amount_currency": currency,
		  "date": DateTime.utc_now()|> DateTime.to_iso8601() 
		}
  end

  def render("new.json", %{ account: account }) when is_map(account) do
  	%{
  		"object" => "Account",
			"currency" => account.currency,
			"kind" => account.kind,
			"meta_data" => account.meta_data,
			"name" => account.name,
			"object_type" => account.object_type,
			"object_uid" => account.object_uid,
			"uid" => account.uid,
			"type" => account.type_id
		}
  end

  def render("show.json", %{ account: account }) when is_map(account) do
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
