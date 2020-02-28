defmodule HayaiLedgerWeb.Schema.Mutations.ProcedureMutations do
	use Absinthe.Schema.Notation

	alias HayaiLedgerWeb.Schema.Resolvers.ProcedureResolver

	object :procedure_mutations do

		field :create_procedure, :procedure do
			arg :action, non_null(:string)
	    arg :description, non_null(:string)
	    arg :name, non_null(:string)
	    arg :type, non_null(:string)

	    resolve &ProcedureResolver.create_procedure/3
		end
	end
end
