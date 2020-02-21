defmodule HayaiLedger.Procedures.ParamsType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "params_types" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(params_type, attrs) do
    params_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
