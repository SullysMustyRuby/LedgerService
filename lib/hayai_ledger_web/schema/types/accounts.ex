defmodule HayaiLedgerWeb.Schema.Types.Accounts do
  use Absinthe.Schema.Notation

  alias HayaiLedgerWeb.Schema.Resolvers.TransactionResolver

  object :account do
    field :active, :boolean
    field :currency, :string
    field :name, :string
    field :object_type, :string
    field :object_uid, :string
    field :uid, :string
    field :type, :string

    field :transactions, list_of(:transaction) do
      arg :amount_currency, :string
      arg :amount_subunits, :integer
      arg :date, :datetime
      arg :kind, :string
      arg :from_date, :datetime
      arg :to_date, :datetime

      resolve &TransactionResolver.all_transactions/3
    end
  end
end
