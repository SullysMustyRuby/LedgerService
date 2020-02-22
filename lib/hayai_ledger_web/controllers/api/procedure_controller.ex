defmodule HayaiLedgerWeb.Api.ProcedureController do
  use HayaiLedgerWeb, :api_controller

  alias HayaiLedger.Procedures

  action_fallback HayaiLedgerWeb.Api.FallbackController

  def process(conn, %{ "procedure" => procedure}) do
  	with {:ok, organization_id} <- organization_id(conn),
  		{:ok, result} <- Procedures.process(procedure, organization_id)
  	do
  		render(conn, "show.json", %{ result: result })
  	end
  end
end
