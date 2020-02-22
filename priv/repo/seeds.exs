# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HayaiLedger.Repo.insert!(%HayaiLedger.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HayaiLedger.Organizations
alias HayaiLedger.Procedures

{:ok, user} = %{ 
	"email" => "sullymustycode@gmail.com", 
	"first_name" => "erin", 
	"last_name" => "boeger", 
	"password" => "Password", 
	"password_confirmation" => "Password"
}
|> Organizations.create_user()

{:ok, organization} = %{
	"description" => "The best ledger system perid!", 
	"name" => "HaiyaiLedger"
}
|> Organizations.create_organization()

%{
  "organization_id" => organization.id,
  "user_id" => user.id
}
|> Organizations.create_membership()

inputs = [
      %{ name: "object_uid" },
      %{ name: "currency" }
    ]

{:ok, cash_asset} = %{
  name: "DefaultCashAsset",
  description: "Create a new cash account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
      %{
        name: "currency", 
        value: "currency",
        type: "inputs"
      },
      %{
        name: "name", 
        value: "Cash",
        type: "string"
      },
      %{
        name: "object_type", 
        value: "Site",
        type: "string"
      },
      %{
        name: "object_uid", 
        value: "object_uid",
        type: "inputs"
      },
      %{
        name: "type", 
        value: "asset",
        type: "string"
      }
    ]
}
|> Procedures.create_procedure()

{:ok, cash_revenue} = %{
  name: "DefaultCashSales",
  description: "Create a new sales revenue account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
      %{
        name: "currency", 
        value: "currency",
        type: "inputs"
      },
      %{
        name: "name", 
        value: "CashSales",
        type: "string"
      },
      %{
        name: "object_type", 
        value: "Site",
        type: "string"
      },
      %{
        name: "object_uid", 
        value: "object_uid",
        type: "inputs"
      },
      %{
        name: "type", 
        value: "revenue",
        type: "string"
      }
    ]
}
|> Procedures.create_procedure()

{:ok, sales_tax} = %{
  name: "DefaultSalesTax",
  description: "Create a new cash account",
  type: "Account",
  action: "create",
  organization_id: organization.id,
  inputs: inputs,
  params: [
      %{
        name: "currency", 
        value: "currency",
        type: "inputs"
      },
      %{
        name: "name", 
        value: "SalesTax",
        type: "string"
      },
      %{
        name: "object_type", 
        value: "Site",
        type: "string"
      },
      %{
        name: "object_uid", 
        value: "object_uid",
        type: "inputs"
      },
      %{
        name: "type", 
        value: "liability",
        type: "string"
      }
    ]
}
|> Procedures.create_procedure()

