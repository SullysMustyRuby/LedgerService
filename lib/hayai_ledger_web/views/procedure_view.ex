defmodule HayaiLedgerWeb.ProcedureView do
  use HayaiLedgerWeb, :view

  def actions() do
  	HayaiLedger.Procedures.Procedure.actions()
  end

  def types() do
  	HayaiLedger.Procedures.Procedure.types()
  end
end