defmodule HayaiLedger.Procedures.ProcedureAction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "procedure_actions" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(procedure_action, attrs) do
    procedure_action
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
