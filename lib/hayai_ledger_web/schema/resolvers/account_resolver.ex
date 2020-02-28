defmodule HayaiLedgerWeb.Schema.Resolvers.AccountResolver do

	alias HayaiLedger.Accounts

	def all_accounts(_root, args, %{ context: %{ organization_id: organization_id } }) do
		accounts = Accounts.list_accounts(organization_id, args)
		{:ok, accounts}
	end

	def find_account(_root, %{ uid: uid }, _context) do
		Accounts.get_account_by_uid(uid)
	end
end
