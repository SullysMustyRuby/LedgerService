defmodule HayaiLedgerWeb.Schema.Queries.ProcedureQueries do
	use Absinthe.Schema.Notation

	alias HayaiLedgerWeb.Schema.Resolvers.ProcedureResolver

	object :procedure_queries do

		@desc "Get all procedures for your organization"
		field :all_procedures, list_of(:procedure) do
			resolve &ProcedureResolver.all_procedures/3
		end

		@desc "Get a single procedure by name"
		field :procedure, :procedure do
			arg :name, non_null(:string)
			resolve &ProcedureResolver.find_procedure/3
		end
	end
end
