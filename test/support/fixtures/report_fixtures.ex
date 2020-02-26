defmodule Support.Fixtures.ReportFixtures do

	import Support.Fixtures.OrganizationFixtures, only: [{:organization_fixture, 0}]

	alias HayaiLedger.Reports

	def report_account_attrs() do
		%{
			"name" => "CashSales",
			"object_type" => "Site",
			"object_uid" => "site_123456789",
			"transaction_report_id" => transaction_report_fixture().id
		}
	end

  def report_account_fixture(attrs \\ %{}) do
    {:ok, report_account} =
      attrs
      |> Enum.into(report_account_attrs())
      |> Reports.create_report_account()

    report_account
  end

	def transaction_report_attrs() do
		%{
			"date_from" => "inputs",
			"date_to" => "inputs",
			"field" => "amount_subunits",
			"name" => "NetSalesReport",
			"timezone" => "Asia/Bangkok",
			"type" => "sum",
			"organization_id" => organization_fixture().id
		}
	end

  def transaction_report_fixture(attrs \\ %{}) do
    {:ok, transaction_report} =
      attrs
      |> Enum.into(transaction_report_attrs())
      |> Reports.create_transaction_report()

    transaction_report
  end

  def net_sales_report(organization_id) do
		{:ok, report} = Reports.create_transaction_report(%{
			"date_from" => "inputs",
			"date_to" => "inputs",
			"field" => "amount_subunits",
			"name" => "NetSalesReport",
			"timezone" => "Asia/Bangkok",
			"type" => "sum",
			"organization_id" => organization_id,
			"accounts" => [
				%{ 
					"name" => "CashSales",
					"object_type" => "Site",
					"object_uid" => "inputs",
					"field" => "amount_subunits"
				},
				%{ 
					"name" => "CreditCardSales",
					"object_type" => "Site",
					"object_uid" => "inputs",
					"field" => "amount_subunits"
				}
			]
		})

		report
  end

  def net_sales_report_params(date_from, date_to, object_uid) do
  	%{
			"name" => "NetSalesReport",
			"inputs" => %{ 
				"object_uid" => object_uid,
				"date_from" => date_from,
				"date_to" => date_to
			}
		}
  end
end
