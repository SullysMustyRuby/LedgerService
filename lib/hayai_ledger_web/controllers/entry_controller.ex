defmodule HayaiLedgerWeb.EntryController do
  use HayaiLedgerWeb, :controller

  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.FallbackController

  # GET
  def show(conn, %{ "uid" => uid }) do
  	with {:ok, entry} <- Ledgers.get_entry_by_uid(uid) do
	  	render(conn, "show.json", %{ entry: entry })
	  end
  end

	# POST
  def create(conn, %{ "journal_entry" => %{ "entry" => entry_attrs, "transactions" => transactions } }) do
  	with transaction_changesets <- Enum.map(transactions, fn(transaction) -> Ledgers.build_transaction(transaction) end),
  		{:ok, entry} <- Ledgers.journal_entry(entry_attrs, transaction_changesets) 
  	do
  		render(conn, "show.json", %{ entry: entry })
  	end
  end

	# POST
  def create(conn, %{ "journal_entry" => %{ "entry" => entry_attrs, "transactions" => transactions, "options" => options } }) do
  	with transaction_changesets <- Enum.map(transactions, fn(transaction) -> Ledgers.build_transaction(transaction) end),
  		{:ok, entry} <- Ledgers.safe_journal_entry(entry_attrs, transaction_changesets, options) 
  	do
  		render(conn, "show.json", %{ entry: entry })
  	end
  end
end