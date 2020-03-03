defmodule HayaiLedgerWeb.Api.ProcedureController do
  use HayaiLedgerWeb, :api_controller

  alias HayaiLedger.Procedures

  action_fallback HayaiLedgerWeb.Api.FallbackController

  def process(conn, %{ "procedure" => procedure }) do
  	with {:ok, organization_id} <- organization_id(conn),
  		{:ok, result} <- Procedures.process(procedure, organization_id)
  	do
  		render(conn, "show.json", %{ result: result })
  	end
  end

  def process(conn, %{ "journal_procedure" => journal_procedure }) do
    with {:ok, organization_id} <- organization_id(conn),
      {:ok, entry, transactions} <- Procedures.process(journal_procedure, organization_id)
    do
      render(conn, "show.json", %{ entry: entry, transactions: transactions })
    end
  end
end
