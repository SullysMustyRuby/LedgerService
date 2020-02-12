defmodule HayaiLedger.Organizations.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Organizations.{Organization, User}

  schema "memberships" do
    field :active, :boolean, default: true
    belongs_to :organization, Organization
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:organization_id, :user_id])
    |> validate_required([:organization_id, :user_id])
    |> foreign_key_constraint(:organization_id)
    |> foreign_key_constraint(:user_id)
  end
end
