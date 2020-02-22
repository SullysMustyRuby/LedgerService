defmodule HayaiLedgerWeb.ParamView do
  use HayaiLedgerWeb, :view

  def types() do
  	HayaiLedger.Procedures.Param.types()
  end
end
