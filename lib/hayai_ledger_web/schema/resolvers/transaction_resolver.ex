defmodule HayaiLedgerWeb.Schema.Resolvers.TransactionResolver do

	alias HayaiLedger.Accounts
	alias HayaiLedger.Accounts.Account
	alias HayaiLedger.Ledgers

	def all_transactions(%Account{ id: account_id }, args, _context) do
		transactions = Map.put(args, :account_id, account_id)
										|> Ledgers.list_transactions()
		{:ok, transactions}
	end

	def all_transactions(_root, args, %{ context: %{ organization_id: organization_id } }) do
		transactions = Map.put(args, :organization_id, organization_id)
										|> Ledgers.list_transactions()
		{:ok, transactions}
	end

	def find_transaction(_root, %{ uid: uid }, _context) do
		Ledgers.get_transaction_by_uid(uid)
	end
end
