defmodule HayaiLedger.Reports.TransactionReport do
  use Ecto.Schema
  import Ecto.Changeset

  alias HayaiLedger.Organizations.Organization
  alias HayaiLedger.Reports.ReportAccount

  @date_from_options ["inputs", "beginning_of_today", "beginning_of_week", "beginning_of_month", "beginning_of_year"]
  @date_to_options ["inputs", "end_of_week", "end_of_month", "end_of_year", "end_of_today"]
  @transaction_fields ["account_uid", "amount_currency", "amount_subunits", "date", "description"]
  @types ["sum", "list", "average"]

  schema "transaction_reports" do
    field :date_from, :string
    field :date_to, :string
    field :field, :string
    field :name, :string
    field :timezone, :string
    field :type, :string
    belongs_to :organization, Organization
    has_many :accounts, ReportAccount

    timestamps()
  end

  @doc false
  def changeset(transaction_report, attrs) do
    transaction_report
    |> cast(attrs, [:date_from, :date_to, :field, :name, :organization_id, :timezone, :type])
    |> validate_required([:date_from, :date_to, :field, :name, :timezone, :type])
    |> cast_assoc(:accounts, with: &ReportAccount.changeset/2)
    |> validate_inclusion(:date_from, @date_from_options)
    |> validate_inclusion(:date_to, @date_to_options)
    |> validate_inclusion(:field, @transaction_fields)
    |> validate_inclusion(:type, @types)
    |> foreign_key_constraint(:organization_id)
  end
end
