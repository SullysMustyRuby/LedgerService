defmodule HayaiLedger.Procedures.GroupProcedure do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Procedures.{Group, Procedure}

  schema "group_procedures" do
    belongs_to :group, Group
    belongs_to :procedure, Procedure

    timestamps()
  end

  @doc false
  def changeset(group_procedure, attrs) do
    group_procedure
    |> cast(attrs, [:group_id, :procedure_id])
    |> validate_required([:group_id, :procedure_id])
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:procedure_id)
  end
end
