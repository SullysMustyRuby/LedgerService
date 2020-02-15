defmodule HayaiLedgerWeb.TransactionController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.FallbackController

  def index(conn, _params) do
    with {:ok, organization_id} <- current_organization_id(conn),
      transactions <- Ledgers.list_transactions(organization_id)
    do
      render(conn, "index.html", transactions: transactions)
    end
  end

  # GET
  def show(conn, %{ "id" => id }) do
    transaction = Ledgers.get_transaction!(id)
    render(conn, "show.html", %{ transaction: transaction })
  end
end
