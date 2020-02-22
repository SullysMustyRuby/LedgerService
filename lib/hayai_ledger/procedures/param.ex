defmodule HayaiLedger.Procedures.Param do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Procedures.Procedure

  @types ["inputs", "string", "integer", "boolean", "list", "map", "date"]

  schema "params" do
    field :name, :string
    field :type, :string
    field :value, :string
    belongs_to :procedure, Procedure

    timestamps()
  end

  @doc false
  def changeset(type_param, attrs) do
    type_param
    |> cast(attrs, [:name, :procedure_id, :type, :value])
    |> validate_required([:name, :type, :value])
    |> validate_inclusion(:type, @types)
    |> foreign_key_constraint(:procedure_id)
  end

  def types(), do: @types

end
