defmodule HayaiLedgerWeb.Schema.Types.Transactions do
	use Absinthe.Schema.Notation

	object :transaction do
		field :amount_currency, :string
		field :amount_subunits, :integer
		field :date, :datetime
		field :description, :string
		field :kind, :string
		field :uid, :string
	end

	object :total do
		field :amount, :integer
	end
end
