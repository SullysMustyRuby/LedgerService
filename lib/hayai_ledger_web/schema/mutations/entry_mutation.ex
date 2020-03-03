defmodule HayaiLedgerWeb.Schema.Mutations.EntryMutations do
	use Absinthe.Schema.Notation

	alias HayaiLedgerWeb.Schema.Resolvers.EntryResolver

	object :entry_mutations do

		field :create_entry, :entry do
	    arg :description, :string
	    arg :object_type, :string
	    arg :object_uid, :string

	    resolve &EntryResolver.create_entry/3
		end

		field :create_journal_entry, :entry do
	    arg :description, :string
	    arg :object_type, :string
	    arg :object_uid, :string
	    arg :transactions, list_of(:transaction_input)

	    resolve &EntryResolver.create_journal_entry/3
		end
	end

	input_object :transaction_input do
	  field :account_uid, non_null(:string)
	  field :amount_subunits, non_null(:integer)
	  field :kind, non_null(:string)
	  field :amount_currency, :string
    field :date, :datetime
    field :description, :string
	end

end
