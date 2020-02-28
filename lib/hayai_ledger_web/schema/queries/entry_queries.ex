defmodule HayaiLedgerWeb.Schema.Queries.EntryQueries do
	use Absinthe.Schema.Notation

	alias HayaiLedgerWeb.Schema.Resolvers.EntryResolver

	object :entry_queries do

		@desc "Get all entrys for your organization"
		field :all_entries, list_of(:entry) do
	    arg :object_type, :string
	    arg :object_uid, :string
			arg :from_date, :datetime
			arg :to_date, :datetime
			arg :limit, :integer
			arg :offset, :integer

			resolve &EntryResolver.all_entries/3
		end

		@desc "Get a single entry"
		field :entry, :entry do
	    arg :uid, non_null(:string)
			
			resolve &EntryResolver.find_entry/3
		end
	end
end