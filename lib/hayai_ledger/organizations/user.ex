defmodule HayaiLedger.Organizations.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :email_confirmation, :boolean, default: false
    field :encrypted_password, :string
    field :first_name, :string
    field :last_name, :string
    field :organization_id, :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:admin, :email, :encrypted_password, :email_confirmation, :first_name, :last_name])
    |> validate_required([:admin, :email, :encrypted_password, :email_confirmation, :first_name, :last_name])
  end
end
