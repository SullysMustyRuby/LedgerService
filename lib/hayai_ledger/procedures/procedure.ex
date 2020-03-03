defmodule HayaiLedger.Procedures.Procedure do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Organizations.Organization
  alias HayaiLedger.Procedures.Param

  @actions ["create"]
  @types ["Account", "Entry", "Transaction"]

  schema "procedures" do
    field :action, :string
    field :description, :string
    field :name, :string
    field :type, :string
    belongs_to :organization, Organization
    has_many :params, Param

    timestamps()
  end

  @doc false
  def changeset(procedure, attrs) do
    procedure
    |> cast(attrs, [:action, :description, :name, :organization_id, :type])
    |> cast_assoc(:params, with: &Param.changeset/2)
    |> validate_required([:action, :description, :name, :organization_id, :type])
    |> validate_inclusion(:action, @actions)
    |> validate_inclusion(:type, @types)
    |> foreign_key_constraint(:organization_id)
  end

  def actions(), do: @actions

  def types(), do: @types
  
end
