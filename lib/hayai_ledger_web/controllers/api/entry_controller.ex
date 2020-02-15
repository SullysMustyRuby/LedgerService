defmodule HayaiLedgerWeb.Api.EntryController do
  use HayaiLedgerWeb, :api_controller

  alias HayaiLedger.Ledgers

  action_fallback HayaiLedgerWeb.Api.FallbackController

  # GET
  def show(conn, %{ "uid" => uid }) do
  	with {:ok, entry} <- Ledgers.get_entry_by_uid(uid) do
	  	render(conn, "show.json", %{ entry: entry })
	  end
  end

	# POST
  def create(conn, %{ "journal_entry" => %{ "entry" => entry_attrs, "transactions" => transactions } }) do
  	with transaction_changesets <- Enum.map(transactions, fn(transaction) -> Ledgers.build_transaction(transaction) end),
      {:ok, organization_id} <- organization_id(conn),
      entry_with_org <- Map.put(entry_attrs, "organization_id", organization_id),
  		{:ok, entry, transactions} <- Ledgers.journal_entry(entry_with_org, transaction_changesets) 
  	do
  		render(conn, "show.json", %{ entry: entry, transactions: transactions })
  	end
  end

	# POST
  def create(conn, %{ "journal_entry" => %{ "entry" => entry_attrs, "transactions" => transactions, "options" => options } }) do
  	with transaction_changesets <- Enum.map(transactions, fn(transaction) -> Ledgers.build_transaction(transaction) end),
  		{:ok, entry, transactions} <- Ledgers.safe_journal_entry(entry_attrs, transaction_changesets, options) 
  	do
  		render(conn, "show.json", %{ entry: entry, transactions: transactions })
  	end
  end
end