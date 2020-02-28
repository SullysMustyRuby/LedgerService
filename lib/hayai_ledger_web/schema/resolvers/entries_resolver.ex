defmodule HayaiLedgerWeb.Schema.Resolvers.EntryResolver do

	alias HayaiLedger.Ledgers

	def all_entries(_root, args, %{ context: %{ organization_id: organization_id } }) do
		entries = Ledgers.list_entries(organization_id, args)
		{:ok, entries}
	end

	def find_entry(_root, %{ uid: uid }, _context) do
		Ledgers.get_entry_by_uid(uid)
	end
end
