defmodule HayaiLedger.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :description, :string
    field :name, :string

    # has_many :memberships = comments, user = author
    # has_many :memberships_users, through: [:memberships, :user]

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
