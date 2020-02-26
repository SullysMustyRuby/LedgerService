defmodule HayaiLedgerWeb.Resolvers.TransactionResolver do

	alias HayaiLedger.Ledgers

	def all_transactions(_root, _args, _info) do
		transactions = Ledgers.list_transactions()
		{:ok, transactions}
	end

end
