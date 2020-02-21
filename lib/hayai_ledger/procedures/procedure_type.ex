defmodule HayaiLedger.Procedures.ProcedureType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "procedure_types" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(procedure_type, attrs) do
    procedure_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
