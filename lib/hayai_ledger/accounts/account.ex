defmodule HayaiLedger.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import HayaiLedger.Helpers, only: [{:generate_uid, 0}]

  alias HayaiLedger.Ledgers.Transaction
  alias HayaiLedger.Organizations.Organization
  alias HayaiLedger.Procedures.Param

  @credit_types ["equity", "liability", "revenue"]
  @debit_types ["asset", "expense"]
  @kinds ["credit", "debit"]
  @types @credit_types ++ @debit_types |> Enum.sort()

  schema "accounts" do
    field :currency, :string
    field :kind, :string
    field :meta_data, :map
    field :name, :string
    field :object_type, :string
    field :object_uid, :string
    field :uid, :string
    field :type, :string
    belongs_to :organization, Organization
    has_many :transactions, Transaction 

    timestamps()
  end

  def apply_params(params, inputs, organization_id) do
    attrs_from_params(params, inputs)
    |> Map.put("organization_id", organization_id)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:currency, :meta_data, :name, :object_type, :object_uid, :organization_id, :type])
    |> put_change(:uid, generate_uid())
    |> validate_required([:currency, :type, :name, :organization_id])
    |> validate_inclusion(:type, @types)
    |> set_kind()
    |> foreign_key_constraint(:organization_id)
  end

  def types(), do: @types

  defp set_kind(%Ecto.Changeset{ changes: %{ type: type } } = changeset) do
    case Enum.member?(@debit_types, type) do
      true -> put_change(changeset, :kind, "debit")
      false -> put_change(changeset, :kind, "credit")
    end
  end

  defp set_kind(changeset), do: changeset

  defp attrs_from_params(params, inputs, attrs \\ %{})

  defp attrs_from_params([], _inputs, attrs), do: attrs

  defp attrs_from_params([ param | tail ], inputs, attrs) do
    attrs_from_params(tail, inputs, put_attr(param, inputs, attrs))
  end

  defp put_attr(%Param{ type: "inputs", name: name}, inputs, attrs) do
    attr_map = Enum.find(inputs, fn(input) -> Map.has_key?(input, name) end)
    Map.put(attrs, name, attr_map[name])
  end

  defp put_attr(%Param{ name: name, value: value}, _inputs, attrs) do
    Map.put(attrs, name, value)
  end
end
