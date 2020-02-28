defmodule HayaiLedgerWeb.Schema.Types.Procedures do
	use Absinthe.Schema.Notation

	object :procedure do
		field :name, non_null(:string)
		field :action, :string
    field :description, :string
    field :type, :string
    field :params, list_of(:param)
	end

	object :param do
		field :name, :string
    field :type, :string
    field :value, :string
    field :procedure, :procedure
	end
end
