defmodule HayaiLedgerWeb.Schema.Resolvers.ProcedureResolver do

	alias HayaiLedger.Procedures

	def all_procedures(_root, _args, %{ context: %{ organization_id: organization_id } }) do
		procedures = Procedures.list_procedures(organization_id)
		{:ok, procedures}
	end

	def find_procedure(root, %{ name: name }, %{ context: %{ organization_id: organization_id } }) do
		Procedures.get_procedure_by_name(name, organization_id)
	end

	def create_procedure(_root, args, %{ context: %{ organization_id: organization_id } }) do
		with full_params <- Map.put(args, :organization_id, organization_id), 
			{:ok, procedure} <- Procedures.create_procedure(full_params) 
		do
			{:ok, procedure}
		else
			{:error, %Ecto.Changeset{ errors: errors }} -> {:error, error_map(errors)}
		end
	end

# fix this
  defp error_map(errors) do
    for {key, {message, _}} <- errors, into: %{} do
      {key, message}
    end
  end
end
