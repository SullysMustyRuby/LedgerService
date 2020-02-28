defmodule HayaiLedgerWeb.Schema.Resolvers.TransactionResolver do

	alias HayaiLedger.Accounts
	alias HayaiLedger.Accounts.Account
	alias HayaiLedger.Ledgers

	def all_transactions(%Account{ id: account_id }, args, _context) do
		transactions = Ledgers.list_transactions(account_id, args)
		{:ok, transactions}
	end

	# def all_transactions(_root, args, %{ context: %{ organization_id: organization_id } }) do
	# 	transactions = Ledgers.list_transactions(organization_id, args)
	# 	{:ok, transactions}
	# end

	def find_transaction(_root, %{ uid: uid }, _context) do
		Ledgers.get_transaction_by_uid(uid)
	end
end
