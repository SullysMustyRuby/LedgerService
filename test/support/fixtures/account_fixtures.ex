defmodule Support.Fixtures.AccountFixtures do

	import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]

	alias HayaiLedger.Accounts

  def account_attrs() do
    object_uid = :crypto.strong_rand_bytes(12) |> Base.url_encode64
  	%{
  		"currency" => "JPY",
      "meta_data" => %{ "customer" => "id" },
      "name" => "some name",
      "object_type" => "Account",
      "object_uid" => object_uid,
  		"type" => "equity",
      "organization_id" => organization_fixture().id,
  	}
  end

	def account_fixture(attrs \\ %{}) do
		{:ok, account} =
      attrs
      |> Enum.into(account_attrs())
      |> Accounts.create_account()

    account
	end
  
  def balance_attrs() do
    %{
      "account_id" => account_fixture().id,
      "amount_currency" => "JPY",
      "amount_subunits" => 0
    }
  end

  def balance_fixture(attrs \\ %{}) do
    {:ok, balance} =
      attrs
      |> Enum.into(balance_attrs())
      |> Accounts.create_balance()

    balance
  end
end
