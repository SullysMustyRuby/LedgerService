defmodule HayaiLedgerWeb.EntryController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.FallbackController

  def index(conn, _params) do
    with {:ok, organization_id} <- current_organization_id(conn),
      entries <- Ledgers.list_entries(organization_id)
    do
      render(conn, "index.html", entries: entries)
    end
  end

  # GET
  def show(conn, %{ "id" => id }) do
    entry = Ledgers.get_entry_with_transactions(id)
    render(conn, "show.html", %{ entry: entry })
  end

  def show(conn, %{ "uid" => uid }) do
    entry = Ledgers.get_entry_by_uid(uid)
    render(conn, "show.html", %{ entry: entry })
  end
end