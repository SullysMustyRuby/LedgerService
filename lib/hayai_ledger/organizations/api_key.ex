defmodule HayaiLedger.Organizations.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Organizations.Encryption, only: [{:generate_salt, 0}, {:generate_token, 2}]
  alias HayaiLedger.Organizations.Organization

  schema "api_keys" do
    field :active, :boolean, default: true
    field :data, :string
    field :kind, :string
    field :token_salt, :binary
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:kind, :organization_id])
    |> validate_required([:kind, :organization_id])
    |> validate_inclusion(:kind, ["full_api", "read_only"])
    |> generate_token()
    |> foreign_key_constraint(:organization_id)
  end

  defp generate_token(%Ecto.Changeset{ changes: %{ organization_id: organization_id, kind: kind } } = changeset) do
    token_salt = generate_salt()
    token = generate_token(token_salt, {kind, organization_id})

    changeset
    |> put_change(:token_salt, token_salt)
    |> put_change(:data, token)
  end

  defp generate_token(changeset), do: changeset
end
