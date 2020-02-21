defmodule HayaiLedger.Procedures.Procedure do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Organizations.Organization
  alias HayaiLedger.Procedures.{Input, ProcedureAction, ProcedureType, TypeParam}

  schema "procedures" do
    field :description, :string
    field :name, :string
    belongs_to :organization, Organization
    belongs_to :action, ProcedureAction
    belongs_to :type, ProcedureType
    has_many :inputs, Input
    has_many :type_params, TypeParam

    timestamps()
  end

  @doc false
  def changeset(procedure, attrs) do
    procedure
    |> cast(attrs, [:action_id, :description, :name, :organization_id, :type_id])
    |> validate_required([:action_id, :description, :name, :organization_id, :type_id])
    |> foreign_key_constraint(:action_id)
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:type_id)
  end
end
