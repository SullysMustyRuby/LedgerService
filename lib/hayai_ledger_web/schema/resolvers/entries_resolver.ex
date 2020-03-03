defmodule HayaiLedgerWeb.Schema.Resolvers.EntryResolver do

	alias HayaiLedger.Ledgers

	def all_entries(_root, args, %{ context: %{ organization_id: organization_id } }) do
		entries = Ledgers.list_entries(organization_id, args)
		{:ok, entries}
	end

	def find_entry(_root, %{ uid: uid }, _context) do
		Ledgers.get_entry_by_uid(uid)
	end

	def create_entry(_root, args, %{ context: %{ organization_id: organization_id } }) do
		with full_params <- Map.put(args, :organization_id, organization_id), 
			{:ok, entry} <- Ledgers.create_entry(full_params) 
		do
			{:ok, entry}
		else
			{:error, %Ecto.Changeset{ errors: errors }} -> {:error, error_map(errors)}
		end
	end

	def create_journal_entry(_root, args, %{ context: %{ organization_id: organization_id } }) do
  	with entry_with_org <- Map.put(args, :organization_id, organization_id) do
  		Ledgers.journal_entry(entry_with_org) 
  	end
  end

  defp error_map(errors) do
  	errors
  end
end
