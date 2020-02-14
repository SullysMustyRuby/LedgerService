defmodule HayaiLedgerWeb.Api.EntryView do
  use HayaiLedgerWeb, :view

  alias HayaiLedger.Ledgers.Entry
  alias HayaiLedgerWeb.Api.TransactionView

  def render("show.json", %{ entry: entry, transactions: transactions }) do
  	%{
      "object" => "Entry",
			"description" => entry.description,
			"object_type" => entry.object_type,
			"object_uid" => entry.object_uid,
			"uid" => entry.uid,
      "transactions" => render_many(transactions, TransactionView, "show.json")
		}
  end

  def render("show.json", %{ entry: entry }) when is_map(entry) do
    %{
      "object" => "Entry",
      "description" => entry.description,
      "object_type" => entry.object_type,
      "object_uid" => entry.object_uid,
      "uid" => entry.uid,
      "transactions" => render_many(entry.transactions, TransactionView, "show.json")
    }
  end

  def render("error.json", %{ errors: errors }) do
  	errors
  end
end
