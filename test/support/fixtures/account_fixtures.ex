defmodule Support.Fixtures.AccountFixtures do

	import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]

	alias HayaiLedger.Accounts

  def account_attrs() do
  	%{
  		"currency" => "JPY",
  		"description" => "some description",
      "kind" => "asset",
  		"name" => "some name",
  		"organization_id" => organization_fixture().id,
  		"type_id" => account_type_fixture().id
  	}
  end

	def account_fixture(attrs \\ %{}) do
		{:ok, account} =
      attrs
      |> Enum.into(account_attrs())
      |> Accounts.create_account()

    account
	end

  def account_type_fixture(attrs \\ %{}) do
  	{:ok, type} =
  		attrs
  		|> Enum.into(account_type_attrs())
  		|> Accounts.create_account_type()

  	type
  end

  def account_type_attrs() do
  	%{ 
  		"name" => "cash" 
  	}
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
