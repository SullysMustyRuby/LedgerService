defmodule HayaiLedger.Procedures.TypeParam do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Procedures.{ParamsType, Procedure}

  schema "type_params" do
    field :name, :string
    field :value, :string
    belongs_to :procedure, Procedure
    belongs_to :type, ParamsType

    timestamps()
  end

  @doc false
  def changeset(type_param, attrs) do
    type_param
    |> cast(attrs, [:name, :procedure_id, :type_id, :value])
    |> validate_required([:name, :procedure_id, :type_id, :value])
    |> foreign_key_constraint(:type_id)
  end
end
