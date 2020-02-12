defmodule HayaiLedger.Organizations.User do
  use Ecto.Schema
  import Ecto.Changeset

  import HayaiLedger.Organizations.Encryption, only: [{:hash_password, 1}]

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :email_confirmation, :boolean, default: false
    field :encrypted_password, :string
    field :first_name, :string
    field :last_name, :string
    field :organization_id, :id
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :password, :password_confirmation])
    |> validate_required([:email, :first_name, :last_name, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> downcase_username()
    |> encrypt_password()
  end

  defp encrypt_password(%Ecto.Changeset{ changes: %{ password: password } } = changeset) when is_binary(password) do
    encrypt_password = hash_password(password)
    put_change(changeset, :encrypted_password, encrypt_password)
  end

  defp encrypt_password(changeset), do: changeset

  defp downcase_username(changeset) do
    changeset
    |> update_change(:first_name, &String.downcase/1)
    |> update_change(:last_name, &String.downcase/1)
  end
end
