defmodule HayaiLedgerWeb.TransactionController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.FallbackController

  # GET
  def show(conn, %{ "uid" => uid }) do
  	with {:ok, transaction} <- Ledgers.get_transaction_by_uid(uid) do
	  	render(conn, "show.json", %{ transaction: transaction })
	  end
  end
end
