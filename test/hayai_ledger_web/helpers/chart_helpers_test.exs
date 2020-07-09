defmodule HayaiLedgerWeb.Helpers.ChartHelpersTest do
	use HayaiLedger.DataCase

	import Support.Fixtures.AccountFixtures
	import Support.Fixtures.LedgerFixtures

	alias HayaiLedger.Ledgers
	alias HayaiLedgerWeb.Helpers.ChartHelpers

	describe "debits_credits/1" do
		test "returns a list with a credits map and debits map" do
			
		end
	end

	describe "sum_by_month/1" do
		test "returns transactions sum by month" do
			account = account_fixture()
			for index <- 1..5 do
				for _ <- 1..3 do
					transaction_fixture(%{
							"account_uid" => account.uid, 
							"amount_subunits" => (1000 + index), 
							"date" => "2020-0#{index}-01T00:00:00Z", 
							"kind" => "credit"}
							)
		      transaction_fixture(%{
		      		"account_uid" => account.uid, 
		      		"amount_subunits" => (100 + index),
		      		"date" => "2020-0#{index}-01T00:00:00Z",
		      		"kind" => "debit"}
		      		)
		    end
	    end 
	    totals = Ledgers.list_transactions(%{account_id: account.id, kind: "credit"})
	    					|> ChartHelpers.sum_by_month()
	    assert totals == [["Jan", 3003], ["Feb", 3006], ["Mar", 3009], ["Apr", 3012], ["May", 3015]]
		end
	end

end
