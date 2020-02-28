defmodule HayaiLedgerWeb.Schema.Types.Entries do
	use Absinthe.Schema.Notation

	# import_types HayaiLedgerWeb.Schema.Types.Transactions

	object :entry do
		field :description, :string
    field :object_type, :string
    field :object_uid, :string
    field :uid, :string
    field :transactions, list_of(:transaction)
	end
end
