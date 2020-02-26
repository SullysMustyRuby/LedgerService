defmodule HayaiLedgerWeb.Schema do

	use Absinthe.Schema

	alias HayaiLedgerWeb.Resolvers.ProcedureResolver

	object :procedure do
		field :action, non_null(:string)
    field :description, non_null(:string)
    field :name, non_null(:string)
    field :type, non_null(:string)
	end

	query do
		field :all_procedures, non_null(list_of(non_null(:procedure))) do
			resolve &ProcedureResolver.all_procedures/3
		end
	end

	mutation do
		field :create_procedure, :procedure do
			arg :action, non_null(:string)
	    arg :description, non_null(:string)
	    arg :name, non_null(:string)
	    arg :type, non_null(:string)

	    resolve &ProcedureResolver.create_procedure/3
		end
	end
	
end
