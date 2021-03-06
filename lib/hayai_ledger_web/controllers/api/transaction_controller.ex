defmodule HayaiLedgerWeb.Api.TransactionController do
  use HayaiLedgerWeb, :api_controller

  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.Api.FallbackController

  # GET
  def show(conn, %{ "uid" => uid }) do
  	with {:ok, transaction} <- Ledgers.get_transaction_by_uid(uid) do
	  	render(conn, "show.json", %{ transaction: transaction })
	  end
  end
end
