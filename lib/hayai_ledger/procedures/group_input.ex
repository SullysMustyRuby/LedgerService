defmodule HayaiLedger.Procedures.GroupInput do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Procedures.Group

  schema "group_inputs" do
    field :name, :string
    belongs_to :group, Group

    timestamps()
  end

  @doc false
  def changeset(group_input, attrs) do
    group_input
    |> cast(attrs, [:name, :group_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:group_id)
  end
end
