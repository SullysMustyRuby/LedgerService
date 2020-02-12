defmodule HayaiLedger.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
