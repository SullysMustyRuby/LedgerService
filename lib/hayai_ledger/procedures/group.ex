defmodule HayaiLedger.Procedures.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Organizations.Organization
  alias HayaiLedger.Procedures.{GroupInput, GroupProcedure, Procedure}

  schema "groups" do
    field :name, :string
    belongs_to :organization, Organization
    has_many :inputs, GroupInput
    many_to_many :procedures, Procedure,
      join_through: GroupProcedure

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :organization_id])
    |> validate_required([:name, :organization_id])
    |> cast_assoc(:inputs, with: &GroupInput.changeset/2)
    |> cast_assoc(:procedures, with: &Procedure.changeset/2)
    |> foreign_key_constraint(:organization_id)
  end
end
