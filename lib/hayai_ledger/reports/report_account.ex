defmodule HayaiLedger.Reports.ReportAccount do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Reports.TransactionReport

  schema "report_accounts" do
    field :name, :string
    field :object_type, :string
    field :object_uid, :string
    belongs_to :transaction_report, TransactionReport

    timestamps()
  end

  @doc false
  def changeset(report_account, attrs) do
    report_account
    |> cast(attrs, [:name, :object_type, :object_uid])
    |> validate_required([:name, :object_type, :object_uid])
    |> foreign_key_constraint(:transaction_report_id)
  end
end
