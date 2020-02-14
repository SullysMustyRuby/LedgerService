defmodule Support.Fixtures.LedgerFixtures do

	import Support.Fixtures.AccountFixtures, only: [{:account_fixture, 0}]

	alias HayaiLedger.Ledgers

  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Ledgers.create_entry()

    entry
  end

	def transaction_attrs() do
		%{
			account_uid: account_fixture().uid,
			amount_currency: "JPY", 
			amount_subunits: 42, 
			kind: "credit"
		}
	end

  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(transaction_attrs())
      |> Ledgers.create_transaction()

    transaction
  end
end